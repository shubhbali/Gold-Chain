import { ethers } from "ethers";
import 'dotenv/config';

const log = console.log;

const TOKEN_HUB = '0x0000000000000000000000000000000000001004'
const unlockReceiver = process.env.UNLOCK_RECEIVER as string;
const operatorPrivateKey = process.env.OPERATOR_PRIVATE_KEY as string;

const RPC_URL = (process.env.RPC_URL as string) || "http://127.0.0.1:8545";
const provider = new ethers.JsonRpcProvider(RPC_URL);

const wallet = new ethers.Wallet(operatorPrivateKey, provider)

// TokenHub
const abiTokenHub = [
    "function withdrawUnlockedToken(address tokenAddress, address recipient) external",
];

const work = async () => {
    log('start work', wallet.address)
    const tokenHub = new ethers.Contract(TOKEN_HUB, abiTokenHub, wallet)

    while (true) {
        try {
            log(new Date().toString(), "try to withdrawUnlockedToken for", unlockReceiver)
            const tx = await tokenHub.withdrawUnlockedToken(ethers.ZeroAddress, unlockReceiver);
            await tx.wait(1);
        } catch (e) {
            log('error', e);
        }
        await sleep(10)
    }
};

const sleep = async (seconds: number) => {
    console.log('sleep', seconds, 's');
    await new Promise((resolve) => setTimeout(resolve, seconds * 1000));
};

const main = async () => {
    await work();
};

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
