import * as fs from "fs";
import * as path from "path";

enum Network {
  MAINNET = "mainnet",
  RINBEKY = "rinkeby"
}

// ------------------------------------------------------------------
// Parser -----------------------------------------------------------
class Parser {
  constructor(
    public text: string,
    public network: string,
    public factoryContract: string,
    public factoryContractStartBlock: string
  ) {}

  parse() {
    let newText = this.replaceNetworks(this.text);

    newText = this.replaceAsset(newText);

    return newText;
  }

  replaceNetworks(text = this.text) {
    return text.replace(/{{NETWORK}}/g, this.network);
  }

  replaceAsset(text = this.text) {
    return text
      .replace(/{{FACTORY_CONTRACT}}/g, this.factoryContract)
      .replace(
        /{{FACTORY_CONTRACT_START_BLOCK}}/g,
        this.factoryContractStartBlock
      );
  }
}

async function readFile(pathFile: string): Promise<string> {
  return new Promise((resolve, reject) => {
    fs.readFile(pathFile, "utf-8", (err, data) =>
      err ? reject(err) : resolve(data)
    );
  });
}

async function deleteFile(pathFile: string): Promise<void> {
  return new Promise((resolve, reject) => {
    if (!fs.existsSync(pathFile)) {
      resolve();
    }

    fs.unlink(pathFile, err => (err ? reject(err) : resolve()));
  });
}

async function writeFile(pathFile: string, data: string): Promise<void> {
  return new Promise((resolve, reject) => {
    fs.writeFile(pathFile, data, "utf-8", err =>
      err ? reject(err) : resolve()
    );
  });
}

class TemplateFile {
  constructor(
    public network: string,
    public factoryContract: string,
    public factoryContractStartBlock: string
  ) {}

  async write(src: string, destination: string) {
    const contents = await readFile(src);

    try {
      const newContents = new Parser(
        contents,
        this.network,
        this.factoryContract,
        this.factoryContractStartBlock
      ).parse();

      await writeFile(destination, newContents);
    } catch (error) {
      await deleteFile(destination);
      throw error;
    }
  }
}

function getNetwork() {
  const network: Network = process.env.NETWORK as Network;

  if (!network || !Object.values(Network).includes(network)) {
    throw new Error("Supply a valid network");
  }

  return network;
}

async function build() {
  const network = getNetwork();

  const factoryContract = process.env.FACTORY_CONTRACT as string;
  const factoryContractStartBlock = process.env
    .FACTORY_CONTRACT_START_BLOCK as string;
  const basePath = path.resolve(__dirname, "../");

  const template = new TemplateFile(
    network,
    factoryContract,
    factoryContractStartBlock
  );

  await Promise.all([
    template.write(
      `${basePath}/src/data/.contracts.ts`,
      `${basePath}/src/data/contracts.ts`
    ),
    template.write(`${basePath}/.subgraph.yaml`, `${basePath}/subgraph.yaml`)
  ]);
}

build().then(() => console.log("All done"));
