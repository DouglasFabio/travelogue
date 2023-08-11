import { SafeAreaView } from "react-native-safe-area-context";
import { View } from "react-native";
import TravelForm from "../components/TravelForm";

export default function Travelogue({navigation}){
    return(
        <SafeAreaView>
            <View>
                <TravelForm/>
            </View>
        </SafeAreaView>
    )
}

