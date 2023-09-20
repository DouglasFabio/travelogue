import React, { useEffect, useState } from 'react';
import { Button, TextInput } from 'react-native-paper';
import { View } from 'react-native';
import { DatePickerInput } from 'react-native-paper-dates';
import axios from 'axios';
import { useNavigation } from '@react-navigation/native';
import Toast from 'react-native-toast-message';
import { EXPO_PUBLIC_API_URL_HTTP_V } from '../env';

export default function TravelForm({ route }) {
  const [name, setName] = useState('');
  const [dateTravel, setDateTravel] = useState(route.params?.dateTravel || null);

  const navigation = useNavigation();

  let url = EXPO_PUBLIC_API_URL_HTTP_V;

  useEffect(() => {
    if (route.params?.travelId) {
      axios.get(`${url}${route.params.travelId}`)
        .then(response => {
          setName(response.data.name);
          setDateTravel(new Date(response.data.dateTravel));
        })
        .catch(error => console.error(error));
    }
  }, [route.params?.travelId]);

  const postTravel = async () => {
    try {
      if (dateTravel === null) {
        Toast.show({
          type: 'error',
          text1: 'Erro',
          text2: 'Por favor, selecione uma data.',
          position: 'bottom'
        });
        return;
      }
      const formattedDate = dateTravel.toISOString().split('T')[0];
      const travelData = {
        name: name,
        dateTravel: formattedDate,
      };

      let response;
      if (route.params?.travelId) {
        const travelData = {
          id: route.params.travelId,
          name: name,
          dateTravel: formattedDate,
        };
        response = await axios.put(`${url}${route.params.travelId}`, travelData);
      } else {
        response = await axios.post(url, travelData);
      }
      Toast.show({
        type: 'success',
        text1: 'Sucesso',
        text2: 'Cadastro realizado com sucesso.',
        position: 'bottom'
      });
      navigation.navigate('TravelList');
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <View style={{ padding: 10 }}>
      <TextInput
        label={'Nome'}
        placeholder={'Digite o nome da viagem'}
        value={name}
        onChangeText={text => setName(text)}
        style={{ marginBottom: 10 }}
      />
      {dateTravel ? (
        <TextInput
          label={'Data'}
          value={dateTravel instanceof Date ? dateTravel.toISOString().split('T')[0] : dateTravel}
          style={{ marginBottom: 10 }}
        />
      ) : (
        <DatePickerInput
          locale="pt-br"
          label={'Data'}
          onChange={date => setDateTravel(date)}
          inputMode="start"
          style={{ marginBottom: 10 }}
        />
      )}
      <Button icon="send" mode="contained" onPress={postTravel}>
        Cadastrar
      </Button>
    </View>
  );
}
