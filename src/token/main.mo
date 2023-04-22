import Principal "mo:base/Principal";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";


actor Token {
    Debug.print("Hi");

    let owner: Principal = Principal.fromText("uwyh4-4vh6y-qufme-thf7e-6lulo-vwhwb-vvtwr-wgau7-g2yvn-tpxgb-qqe");
    let totalSupply: Nat = 1000000000;
    let symbol: Text = "DRD";

    private stable var balanceEntries: [(Principal, Nat)] = [];

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    if(balances.size() < 1) {
        balances.put(owner, totalSupply);
    };

    public query func balanceOf(who: Principal) : async Nat {
        
        let balance : Nat = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };
        return balance;
    };

    public query func getSymbol(): async Text {
        return symbol;
    };

    public shared(msg) func payOut(): async Text {
        // Debug.print(debug_show(msg.caller));
        if(balances.get(msg.caller) == null) {
            let amount = 10000;
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "Already Claimed";
        }
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
        let fromBalance = await balanceOf(msg.caller);
        if (fromBalance >= amount) {
            balances.put(msg.caller, (fromBalance - amount));
            
            let toBalance = await balanceOf(to);
            balances.put(to, (toBalance + amount));
            return "Success";
        } else {
            return "Insufficient Funds";
        }
    };

    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);

        if(balances.size() < 1) {
            balances.put(owner, totalSupply);
        };
    };
}