import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import Travelogue from './screens/HomeScreen';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator initialRouteName="travelogue" backBehavior='history'   screenOptions={{tabBarActiveTintColor: "crimson"}}>
        <Tab.Screen name='Travelogue' component={Travelogue} options={{
          tabBarLabel: 'Travelogue', tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="home" size={size} color={color} />
          )
        }} />
        <Tab.Screen name='Travelogue' component={Travelogue} options={{
          tabBarLabel: 'Travelogue', tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="home" size={size} color={color} />
          )
        }} />
      </Tab.Navigator>
      <StatusBar style="auto" />
    </NavigationContainer>
  );
}