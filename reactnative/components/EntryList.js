import React, { useState, useEffect } from 'react';
import { View, ScrollView, RefreshControl } from 'react-native';
import { Avatar, Card, Button, IconButton, FAB } from 'react-native-paper';
import axios from 'axios';
import { EXPO_PUBLIC_API_URL_HTTP_E } from '../env';

const EntryList = ({ navigation, route }) => {

    let url = EXPO_PUBLIC_API_URL_HTTP_E;

    const [data, setData] = useState([]);
    const [refreshing, setRefreshing] = useState(false);

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = () => {
        axios.get(`${url}/${route.params.travelId}`)
            .then(response => {
                setData(response.data);
                setRefreshing(false);
            })
            .catch(error => {
                console.log(error);
            });
    };

    const AddEntry = () => {
        navigation.navigate('EntryForm', {id: route.params.travelId});
    }

    const onRefresh = () => {
        setRefreshing(true);
        fetchData();
    };

    const handleEdit = (travel) => {
        navigation.navigate('EntryEdit', { entryId: travel.id, visitedLocal: travel.visitedLocal, dateVisit: travel.dateVisit, description: travel.description, codTravel: travel.codTravel });
      };
    
      const handleDelete = (id) => {
        axios.delete(`${url}/${id}`)
          .then(response => {
            setData(data.filter(travel => travel.id !== id));
          })
          .catch(error => {
            console.log(error);
          });
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
                                title={travel.visitedLocal}
                                subtitle={travel.dateVisit}
                                left={(props) => <Avatar.Icon {...props} icon="wallet-travel" />}
                            />
                            <Card.Actions>
                                <IconButton
                                    onPress={() => navigation.navigate('ImageGallery', { id: travel.id })}
                                    icon="image-multiple"
                                />
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
                onPress={() => AddEntry()}
            />
        </>
    );
};

export default EntryList;
