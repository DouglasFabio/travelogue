import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import TravelList from './components/TravelList';
import Toast from 'react-native-toast-message';
import TravelForm from './components/TravelForm';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name='list' component={TravelList} options={{title: 'Travelogue'}}/>
        <Stack.Screen name='form' component={TravelForm} options={{title: 'Travelogue'}}/>
        </Stack.Navigator>
      <StatusBar style="auto" />
      <Toast/>
    </NavigationContainer>
  );
}