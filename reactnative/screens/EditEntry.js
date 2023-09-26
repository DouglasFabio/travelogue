import { SafeAreaView } from "react-native-safe-area-context";
import { View } from "react-native";
import EntryEdit from "../components/EntryEdit";

export default function EditTravel({navigation}){
    return(
        <SafeAreaView>
            <View>
                <EntryEdit/>
            </View>
        </SafeAreaView>
    )
}

