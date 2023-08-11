import { SafeAreaView } from "react-native-safe-area-context";
import { View } from "react-native";
import TravelList from "../components/TravelList";

export default function Travelogue({navigation}){
    return(
        <SafeAreaView>
            <View>
                <TravelList/>
            </View>
        </SafeAreaView>
    )
}

