import { PetraWallet } from "petra-plugin-wallet-adapter";
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";

import { AutoConnectProvider } from "./AutoConnectProvider";
import { FC, ReactNode } from "react";
import { AlertProvider, useAlert } from "./AlertProvider";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient();

const WalletContextProvider: FC<{ children: ReactNode }> = ({ children }) => {
  const { setErrorAlertMessage } = useAlert();

  const wallets = [new PetraWallet()];

  return (
    <AptosWalletAdapterProvider
      plugins={wallets}
      autoConnect={true}
      onError={(error) => {
        console.log("Custom error handling", error);
        setErrorAlertMessage(error);
      }}
    >
      {children}
    </AptosWalletAdapterProvider>
  );
};

export const AppContext: FC<{ children: ReactNode }> = ({ children }) => {
  return (
    <QueryClientProvider client={queryClient}>
      <AutoConnectProvider>
        <AlertProvider>
          <WalletContextProvider>{children}</WalletContextProvider>
        </AlertProvider>
      </AutoConnectProvider>
    </QueryClientProvider>
  );
};
