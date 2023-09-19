// @flow
import { useNavigation } from '@react-navigation/native';
import React, { useEffect, useState } from 'react';
import { Button, Text, TextInput } from "react-native-paper";
import { DatePickerInput } from "react-native-paper-dates";
import { View } from 'react-native';
import ImagePicker from 'react-native-image-picker';
import axios from 'axios';
import Toast from 'react-native-toast-message';

export default function EntryForm({ route }) {

  const [visitedLocal, setVisitedLocal] = useState('');
  const [dateVisit, setDateVisit] = useState(null);
  const [description, setDescription] = useState('');
  const [midiaPath, setMidiaPath] = useState('');
  const [codTravel, setCodTravel] = useState()

  const navigation = useNavigation(); 
  const idViagem = route.params.id;

  let url = `http://10.0.2.2:5000/api/Entrada/`;

  const postEntry = async () => {
    try {
      if (dateVisit === null) {
        Toast.show({
          type: 'error',
          text1: 'Erro',
          text2: 'Por favor, selecione uma data.',
          position: 'bottom'
        });
        return;
      }
      const formattedDate = dateVisit.toISOString().split('T')[0];
  
      const entryData = {
        visitedLocal: visitedLocal,
        dateVisit: formattedDate,
        description: description,
        midiaPath: midiaPath,
        codTravel: idViagem
      };
      response = await axios.post(url, entryData);
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

  const galeria = () => {
    const options = {
      title: 'Selecione uma imagem',
      storageOptions: {
        skipBackup: true,
        path: 'images',
      },
    };

    ImagePicker.launchImageLibrary(options, (response) => {
      if (response.didCancel) {
        console.log('O usuário cancelou a seleção de imagem');
      } else if (response.error) {
        console.log('Erro na seleção de imagem: ', response.error);
      } else {
        console.log('Caminho da imagem selecionada: ', response.path);
      }
    });
  };

  const camera = () => {
    const options = {
      title: 'Tire uma foto',
      storageOptions: {
        skipBackup: true,
        path: 'images',
      },
    };

    ImagePicker.launchCamera(options, (response) => {
      if (response.didCancel) {
        console.log('O usuário cancelou a captura da foto');
      } else if (response.error) {
        console.log('Erro na captura da foto: ', response.error);
      } else {
        console.log('Caminho da foto capturada: ', response.path);
      }
    });
  };

  return (
    <View style={{ padding: 10 }}>
      <TextInput
        label={'Local visitado'}
        placeholder={'Digite o local visitado'}
        value={visitedLocal}
        onChangeText={text => setVisitedLocal(text)}
        style={{ marginBottom: 10 }}
      />
      {dateVisit ? (
        <TextInput
          label={'Data Visita'}
          value={dateVisit instanceof Date ? dateVisit.toISOString().split('T')[0] : dateVisit}
          style={{ marginBottom: 10 }}
        />
      ) : (
        <DatePickerInput
          locale="pt-br"
          label={'Data Visita'}
          onChange={date => setDateVisit(date)}
          inputMode="start"
          style={{ marginBottom: 10 }}
        />
      )}
      <TextInput
        label={'Descrição'}
        placeholder={'Digite a descrição da visita'}
        value={description}
        onChangeText={text => setDescription(text)}
        style={{ marginBottom: 10 }}
      />
      <Text style={{fontSize: 20, textAlign: 'center'}}>Registro de imagens</Text>
      <Button icon="file" onPress={galeria}>Abrir Galeria</Button>
      <Button icon="camera" onPress={camera}>Abrir Câmera</Button>
      <Button icon="send" mode="contained" onPress={postEntry}>
        Registrar
      </Button>
    </View>
  );
}

