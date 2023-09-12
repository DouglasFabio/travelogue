import { SafeAreaView } from "react-native-safe-area-context";
import { View } from "react-native";
import TravelEdit from "../components/TravelEdit";

export default function EditTravel({navigation}){
    return(
        <SafeAreaView>
            <View>
                <TravelEdit/>
            </View>
        </SafeAreaView>
    )
}

