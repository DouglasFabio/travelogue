import React, { useState } from 'react';
import { Button, TextInput } from 'react-native-paper';
import { View } from 'react-native';
import { DatePickerInput } from 'react-native-paper-dates';
import axios from 'axios';
import { useNavigation } from '@react-navigation/native';

export default function TravelForm() {
  const [name, setName] = useState('');
  const [dateTravel, setDateTravel] = useState(null);
  const navigation = useNavigation();

  let url = `http://10.0.2.2:5000/api/Viagem/`;

  const postTravel = async () => {
    try {
      const formattedDate = dateTravel.toISOString().split('T')[0];
      const response = await axios.post(url, {
        name: name,
        dateTravel: formattedDate,
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
        onChangeText={text => setName(text)}
        style={{ marginBottom: 10 }}
      />
      <DatePickerInput
        locale="pt-br"
        label={'Data'}
        value={dateTravel}
        onChange={date => setDateTravel(date)}
        inputMode="start"
        style={{ marginBottom: 10 }}
      />
      <Button icon="send" mode="contained" onPress={postTravel}>
        Cadastrar
      </Button>
    </View>
  );
}
