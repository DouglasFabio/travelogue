import { SafeAreaView } from "react-native-safe-area-context";
import { View } from "react-native";
import EntryForm from "../components/EntryForm";

export default function AddEntry({navigation}){
    return(
        <SafeAreaView>
            <View>
                <EntryForm/>
            </View>
        </SafeAreaView>
    )
}

