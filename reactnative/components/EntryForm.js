// @flow
import { useNavigation } from '@react-navigation/native';
import React, { useEffect, useState } from 'react';
import { Button, Text, TextInput } from "react-native-paper";
import { DatePickerInput } from "react-native-paper-dates";
import { View } from 'react-native';
import * as ImagePicker from 'expo-image-picker';
import axios from 'axios';
import Toast from 'react-native-toast-message';
import { EXPO_PUBLIC_API_URL_HTTP_E } from '../env';

export default function EntryForm({ route }) {

  const [visitedLocal, setVisitedLocal] = useState('');
  const [dateVisit, setDateVisit] = useState(null);
  const [description, setDescription] = useState('');
  const [midiaPath, setMidiaPath] = useState('');
  const [codTravel, setCodTravel] = useState();


  const navigation = useNavigation();
  const idViagem = route.params.id;

  let url = EXPO_PUBLIC_API_URL_HTTP_E;

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
      if (midiaPath.length === 0) {
        Toast.show({
          type: 'error',
          text1: 'Erro',
          text2: 'Por favor, selecione uma imagem.',
          position: 'bottom'
        });
        return;
      }
      if(visitedLocal === "" || description === ""){
        Toast.show({
          type: 'error',
          text1: 'Erro',
          text2: 'Por favor, preencha todos os campos!',
          position: 'bottom'
        });
        return;
      }

      const formattedDate = dateVisit.toISOString().split('T')[0];
      let midiaPathString = midiaPath.join(',');

      const entryData = {
        visitedLocal: visitedLocal,
        dateVisit: formattedDate,
        description: description,
        midiaPath: midiaPathString,
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

  const permissaoGC = async () => {
    const { status: cameraStatus } = await ImagePicker.requestCameraPermissionsAsync();
    const { status: galeriaStatus } = await ImagePicker.requestPermissionsAsync();
  
    if (cameraStatus !== 'granted' || galeriaStatus !== 'granted') {
      alert('Desculpe, precisamos de permissões de câmera e galeria para fazer isso funcionar!');
    }
  };

  const galeria = async () => {
    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      allowsEditing: true,
      quality: 1,
    });

    if (!result.cancelled) {
      result.assets.forEach(asset => {
        setMidiaPath([...midiaPath, asset.uri]);
      });
    }
  };

  const camera = async () => {
    try {
      let result = await ImagePicker.launchCameraAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.All,
        allowsEditing: true,
        aspect: [4, 3],
        quality: 1,
      });
  
      if (!result.cancelled) {
        result.assets.forEach(asset => {
          setMidiaPath([...midiaPath, asset.uri]);
        });
      }
    } catch (error) {
      console.error('Erro ao abrir a câmera:', error);
    }
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
      <Text style={{ fontSize: 20, textAlign: 'center' }}>Registro de imagens</Text>
      <Text style={{ fontSize: 16, textAlign: 'center' }}>{`Imagens selecionadas: ${midiaPath.length}`}</Text>
      <Button icon="check" onPress={permissaoGC}>Permitir Galeria / Camera</Button>
      <Button icon="file" onPress={galeria}>Abrir Galeria</Button>
      <Button icon="camera" onPress={camera}>Abrir Câmera</Button>
      <Button icon="send" mode="contained" onPress={postEntry}>
        Registrar
      </Button>
    </View>
  );
}

