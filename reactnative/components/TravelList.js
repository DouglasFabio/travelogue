import React, { useState, useEffect } from 'react';
import { View } from 'react-native';
import { Avatar, Card } from 'react-native-paper';
import axios from 'axios';

const TravelList = () => {
  const [data, setData] = useState(null);

  useEffect(() => {
    axios.get('http://10.0.2.2:5000/api/Viagem')
      .then(response => {
        console.log(response.data);
        setData(response.data)
      })
      .catch(error => {
        console.log(error);
      })
  }, []);

  return (
    <View>
      {data ? (
        <Card>
          <Card.Title
            title={data.name}
            subtitle={data.dateTravel}
            left={(props) => <Avatar.Icon {...props} icon="wallet-travel" />}
          />
        </Card>
      ) : null}
    </View>
  );
};

export default TravelList;
