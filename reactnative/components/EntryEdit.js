import React, { useEffect, useRef, useState } from 'react';
import { Button, Text, TextInput } from 'react-native-paper';
import { View } from 'react-native';
import { DatePickerInput } from 'react-native-paper-dates';
import * as ImagePicker from 'expo-image-picker';
import axios from 'axios';
import { useNavigation } from '@react-navigation/native';
import Toast from 'react-native-toast-message';
import { EXPO_PUBLIC_API_URL_HTTP_E, EXPO_PUBLIC_API_URL_HTTP_EE } from '../env';
import { date } from 'yup';

export default function EntryEdit({ route }) {
    const [visitedLocal, setVisitedLocal] = useState(route.params.visitedLocal || '');
    const [dateVisit, setDateVisit] = useState(route.params.dateVisit || null);
    const [description, setDescription] = useState(route.params.description || '');
    const [midiaPath, setMidiaPath] = useState('');
    const [codTravel, setCodTravel] = useState(route.params.codTravel || '');
    const [load, setLoad] = useState(false);
    console.log(route.params.entryId);
    const navigation = useNavigation();

    let urlGet = EXPO_PUBLIC_API_URL_HTTP_EE;
    let urlPut = EXPO_PUBLIC_API_URL_HTTP_E;
    useEffect(() => {
        if (route.params?.entryId) {
            axios.get(`${urlGet}/${route.params.entryId}`)
                .then(response => {
                    setVisitedLocal(response.data.visitedLocal);
                    setDescription(response.data.description);
                    setDateVisit(new Date(response.data.dateVisit));
                    setCodTravel(response.data.codTravel);
                    setLoad(true);
                })
                .catch(error => console.error(error));
        }
    }, [load]);

    const putEntry = async () => {
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
            if (visitedLocal === "" || description === "") {
                Toast.show({
                    type: 'error',
                    text1: 'Erro',
                    text2: 'Por favor, preencha todos os campos!',
                    position: 'bottom'
                });
                return;
            }

            //const formattedDate = route.params.dateVisit.toISOString().split('T')[0];
            let midiaPathString = midiaPath.join(',');

            const entryData = {
                id: route.params.entryId,
                visitedLocal: visitedLocal,
                dateVisit: dateVisit,
                description: description,
                midiaPath: midiaPathString,
                codTravel: codTravel
            };
            
            let response = await axios.put(`${urlPut}/${route.params.entryId}`, entryData);
            Toast.show({
                type: 'success',
                text1: 'Sucesso',
                text2: JSON.stringify(response.data),
                position: 'bottom'
            });
            navigation.navigate('EntryList');

        }
        catch (error) {
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
                label={'Local Visitado'}
                placeholder={'Digite o local visitado'}
                value={visitedLocal}
                onChangeText={text => setVisitedLocal(text)}
                style={{ marginBottom: 10 }}
            />
            <TextInput disabled
                label={'Data Visita'}
                value={route.params.dateVisit instanceof Date ? route.params.dateVisit.toISOString().split('T')[0] : route.params.dateVisit}
                style={{ marginBottom: 10 }}
            />
            <DatePickerInput
                locale="pt-br"
                label={'Data Nova'}
                onChange={date => setDateVisit(date)}
                inputMode="start"
                style={{ marginBottom: 10 }}
            />
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
            <Button icon="send" mode="contained" onPress={putEntry}>
                Atualizar
            </Button>
        </View>
    );
}
