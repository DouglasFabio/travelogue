import React, { useEffect, useRef, useState } from 'react';
import { Button, TextInput } from 'react-native-paper';
import { View } from 'react-native';
import { DatePickerInput } from 'react-native-paper-dates';
import axios from 'axios';
import { useNavigation } from '@react-navigation/native';
import Toast from 'react-native-toast-message';

export default function TravelEdit({ route }) {
  const [name, setName] = useState('');
  const [dateTravel, setDateTravel] = useState(route.params?.dateTravel || null);
  const [load, setLoad] = useState(false);
  const dateTravelRef = useRef(dateTravel);

  const navigation = useNavigation();

  let url = `http://10.0.2.2:5000/api/Viagem/`;

  useEffect(() => {
    if (route.params?.travelId && !dateTravelRef.current) {
      axios.get(`${url}${route.params.travelId}`)
        .then(response => {
          setName(response.data.name);
          setDateTravel(new Date(response.data.dateTravel));
          setLoad(true);
        })
        .catch(error => console.error(error));
    }
  }, [load]);

  const putTravel = async () => {
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
        id: route.params.travelId,
        name: name,
        dateTravel: formattedDate,
      };
      let response = await axios.put(`${url}${route.params.travelId}`, travelData);
      Toast.show({
        type: 'success',
        text1: 'Sucesso',
        text2: JSON.stringify(response.data),
        position: 'bottom'
      });
      console.log(response.data);
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
        <TextInput disabled
          label={'Data'}
          value={dateTravel instanceof Date ? dateTravel.toISOString().split('T')[0] : dateTravel}
          style={{ marginBottom: 10 }}
        />
        <DatePickerInput
          locale="pt-br"
          label={'Data Nova'}
          onChange={date => setDateTravel(date)}
          inputMode="start"
          style={{ marginBottom: 10 }}
        />
      <Button icon="send" mode="contained" onPress={putTravel}>
        Atualizar
      </Button>
    </View>
  );
}
