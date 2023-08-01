import { useWallet } from "@aptos-labs/wallet-adapter-react";
import dynamic from "next/dynamic";
import { useAlert } from "../components/AlertProvider";
import { Button } from "antd";
import { useQuery } from "@tanstack/react-query";
import { AptosClient } from "aptos";

const WalletButtons = dynamic(() => import("../components/WalletButtons"), {
  suspense: false,
  ssr: false,
});

export const DEVNET_NODE_URL = "https://fullnode.devnet.aptoslabs.com/v1";
export const DEMO_ADDR =
  "0xb6eff43b80b064592d0fd78c6ab510c86c50b7700f31aed87ecca7053bfec468";

const client = new AptosClient(DEVNET_NODE_URL);

export default function App() {
  const { connect, account, signAndSubmitTransaction, disconnect } = useWallet();

  const { setSuccessAlertHash, setErrorAlertMessage } = useAlert();

  const name = useQuery(["name", account?.address], async () => {
    return (await client.view({
      function: `${DEMO_ADDR}::name::name`,
      type_arguments: [],
      arguments: [account?.address],
    })) as unknown as string;
  });

  return (
    <div className="mt-16 ml-8">
      <h1 className="text-4xl font-extrabold tracking-tight leading-none text-black">
        Move Demo App
      </h1>
      <div className="mt-8">
        {!account ? (
          <div>
            <WalletButtons />
          </div>
        ) : (
          <>
            <h3>
              Connected with {account.address} ({name.data})
            </h3>
            <div className="flex gap-4 mt-4">
              <Button
                className="bg-blue-500 text-white"
                onClick={async () => {
                  const nameStr = prompt("Enter a name");
                  if (!nameStr) return alert("No name specified");
                  try {
                    const tx = await signAndSubmitTransaction({
                      type: "entry_function_payload",
                      function: `${DEMO_ADDR}::name::set_name`,
                      type_arguments: [],
                      arguments: [nameStr],
                    });
                    setSuccessAlertHash(tx.hash);
                    await name.refetch();
                  } catch (e: any) {
                    setErrorAlertMessage(e.message);
                  }
                }}
              >
                Set Name
              </Button>
              <Button onClick={disconnect}>Disconnect</Button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
