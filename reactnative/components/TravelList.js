import * as React from 'react';
import { Avatar, Card, IconButton } from 'react-native-paper';

export default TravelList = () => (
  <Card.Title
    title="Londres"
    subtitle="27-06-2022"
    left={(props) => <Avatar.Icon {...props} icon="wallet-travel" />}
    right={(props) => 
      <IconButton {...props} icon="plus-circle-outline" onPress={() => {}}/>}
  />
);