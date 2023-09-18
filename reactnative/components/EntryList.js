import React, { useState, useEffect } from 'react';
import { View, ScrollView, RefreshControl } from 'react-native';
import { Avatar, Card, Button, IconButton, FAB } from 'react-native-paper';
import axios from 'axios';

const EntryList = ({ navigation, route }) => {

    let url = `http://10.0.2.2:5000/api/Entrada/`;

    const [data, setData] = useState([]);
    const [refreshing, setRefreshing] = useState(false);

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = () => {
        axios.get(`${url}${route.params.travelId}`)
            .then(response => {
                setData(response.data);
                setRefreshing(false);
            })
            .catch(error => {
                console.log(error);
            });
    };

    const AddEntry = () => {
        navigation.navigate('EntryForm');
    }

    const galeria = (travel) => {
        navigation.navigate('ImageGallery', { travel });
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
                                title={travel.visitedLocal}
                                subtitle={travel.dateVisit}
                                left={(props) => <Avatar.Icon {...props} icon="wallet-travel" />}
                            />
                            <Card.Actions>
                                <IconButton onPress={() => galeria(travel)} icon="image-multiple" />
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
