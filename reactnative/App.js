import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import TravelList from './components/TravelList';
import Toast from 'react-native-toast-message';
import TravelForm from './components/TravelForm';
import EntryForm from './components/EntryForm';
import TravelEdit from './components/TravelEdit';
import EntryList from './components/EntryList';
import ImageGallery from './components/ImageGallery';
import EntryEdit from './components/EntryEdit';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name='TravelList' component={TravelList} options={{ title: 'Travelogue' }} />
        <Stack.Screen name='TravelForm' component={TravelForm} options={{ title: 'Cadastro de viagens' }} />
        <Stack.Screen name='EntryForm' component={EntryForm} options={{ title: 'Nova Entrada' }} />
        <Stack.Screen name='TravelEdit' component={TravelEdit} options={{ title: 'Editar viagem' }} />
        <Stack.Screen name='EntryList' component={EntryList} options={{ title: 'Entradas Diárias' }} />
        <Stack.Screen name='ImageGallery' component={ImageGallery} options={{ title: 'Galeria' }} />
        <Stack.Screen name='EntryEdit' component={EntryEdit} options={{ title: 'Editar entrada' }} />
      </Stack.Navigator>
      <StatusBar style="auto" />
      <Toast />
    </NavigationContainer>
  );
}