import React, { useState, useEffect } from 'react';
import { View, ScrollView, RefreshControl } from 'react-native';
import { Avatar, Card, Button, IconButton, FAB } from 'react-native-paper';
import axios from 'axios';
import { EXPO_PUBLIC_API_URL_HTTP_V } from '../env';
import * as LocalAuthentication from 'expo-local-authentication';

const TravelList = ({ navigation }) => {

  let url = EXPO_PUBLIC_API_URL_HTTP_V;

  const [data, setData] = useState([]);
  const [refreshing, setRefreshing] = useState(false);
  const [autenticado, setAutenticado] = useState(false);

  const autenticar = async () => {
    const auth = await LocalAuthentication.authenticateAsync({
      promptMessage: 'Por favor, realize a autenticação.'
    });
    setAutenticado(auth.success);
  }

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = () => {
    axios.get(url)
      .then(response => {
        setData(response.data);
        setRefreshing(false);
      })
      .catch(error => {
        console.log(error);
      });
  };

  const AddTravel = () => {
    navigation.navigate('TravelForm');
  }

  const handleEdit = (travel) => {
    navigation.navigate('TravelEdit', { travelId: travel.id });
  };

  const handleDelete = async (id) => {
    await autenticar();
    if (autenticado) {
      axios.delete(`${url}/${id}`)
        .then(response => {
          setData(data.filter(travel => travel.id !== id));
        })
        .catch(error => {
          console.log(error);
        });
    }
  };

  const onRefresh = () => {
    setRefreshing(true);
    fetchData();
  };

  return (
    <>
      <ScrollView
        contentContainerStyle={{ flexGrow: 1 }}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        <View>
          {data.map((travel) => (
            <Card key={travel.id}>
              <Card.Title
                title={travel.name}
                subtitle={travel.dateTravel}
                left={(props) => <Avatar.Icon {...props} icon="wallet-travel" />}
              />
              <Card.Actions>
                {travel.name ? (
                  <Button onPress={() => navigation.navigate('EntryList', { travelId: travel.id })}>Ver entradas</Button>
                ) : (
                  <Button buttonColor='lightcoral' onPress={() => navigation.navigate('TravelForm', { travelId: travel.id, dateTravel: travel.dateTravel })}>Completar cadastro</Button>
                )}
                <IconButton onPress={() => handleEdit(travel)} icon="pencil" />
                <IconButton onPress={() => handleDelete(travel.id)} icon="delete" iconColor='red' />
              </Card.Actions>
            </Card>
          ))}
        </View>
      </ScrollView>
      <FAB
        style={{
          position: 'absolute',
          margin: 16,
          right: 0,
          bottom: 0,
        }}
        small
        icon="plus"
        onPress={() => AddTravel()}
      />
    </>
  );
};

export default TravelList;
