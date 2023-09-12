import React, { useState, useEffect } from 'react';
import { View, ScrollView, RefreshControl } from 'react-native';
import { Avatar, Card, Button, IconButton } from 'react-native-paper';
import axios from 'axios';

const TravelList = ({ navigation }) => {

  let url = `http://10.0.2.2:5000/api/Viagem/`;

  const [data, setData] = useState([]);
  const [refreshing, setRefreshing] = useState(false);

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

  const handleEdit = (travel) => {
    navigation.navigate('TravelEdit', { travel });
  };

  const handleDelete = (id) => {
    axios.delete(`${url}${id}`)
      .then(response => {
        setData(data.filter(travel => travel.id !== id));
      })
      .catch(error => {
        console.log(error);
      });
  };

  const onRefresh = () => {
    setRefreshing(true);
    fetchData();
  };

  return (
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
              <Button onPress={() => navigation.navigate('EntryForm', { travelId: travel.id })}>Registrar entrada</Button>
              <IconButton onPress={() => handleEdit(travel)} icon="pencil"/>
              <IconButton onPress={() => handleDelete(travel.id)} icon="delete" iconColor='red'/>
            </Card.Actions>
          </Card>
        ))}
      </View>
    </ScrollView>
  );
};

export default TravelList;
