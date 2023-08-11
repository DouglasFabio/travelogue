import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import Travelogue from './screens/HomeScreen';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';
import AddTravel from './screens/AddTravel';

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator initialRouteName="Travelogue" backBehavior='history'   screenOptions={{tabBarActiveTintColor: "crimson"}}>
        <Tab.Screen name='Travelogue' component={Travelogue} options={{
          tabBarLabel: 'Travelogue', tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="home" size={size} color={color} />
          )
        }} />
        <Tab.Screen name='Nova viagem' component={AddTravel} options={{
          tabBarLabel: 'Nova viagem', tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="airplane-plus" size={size} color={color} />
          )
        }} />
      </Tab.Navigator>
      <StatusBar style="auto" />
    </NavigationContainer>
  );
}