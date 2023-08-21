import { SafeAreaView } from "react-native-safe-area-context";
import { StyleSheet, Text, View } from "react-native";
import { globalStyles } from "../estilos";
import { useEffect, useState } from "react";
import { Toast } from "react-native-toast-message/lib/src/Toast";
import { SwipeListView } from 'react-native-swipe-list-view';
import { Pressable } from "react-native";
import { Button } from "react-native";
import { RefreshControl } from "react-native";

export default function TravelList() {

  const [busy, setBusy] = useState(false);
  const [update, setUpdate] = useState(true);
  const [data, setData] = useState(null);

  useEffect(() => {
    if (update) {
      atualizarLista();
      setUpdate(false);
    }
  }, [update]);


  const atualizarLista = () => {
    setBusy(p => true);
    fetch('https://10.0.2.2:7298/api/Viagem',
      {
        method: 'GET',
        mode: 'cors', 
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      }).then((p) => {
        if (p.status === 200) {
          p.json().then((x) => {
            setData(x);
            setBusy(p => false);
            console.log(x);
            console.log(p);
          }).catch((e) => {
            Toast.show({
              type: 'error',
              text1: 'Erro',
              text2: 'Houve um erro ao buscar os dados',
              position: 'bottom'
            }); setBusy(p => false);
          });
        }
        else {
          Toast.show({
            type: 'error', text1: 'Erro', text2: p.statusText, position: 'bottom'
          });
          setBusy(p => false);
        }
      }).catch((e) => {
        Toast.show({
          type: 'error', text1: 'Erro', text2: 'Houve um erro ao buscar os dados', position: 'bottom'
        });
        setBusy(p => false);
      });


    return (
      //<Card>
      //  {data && (
      //    <Card.Title
      //      title={data.name}
      //      subtitle={data.dateTravel}
      //      left={(props) => <Avatar.Icon {...props} icon="wallet-travel" />}
      //    />
      //  )}
      //</Card>

      <SafeAreaView style={globalStyles.container}>
        <View style={localStyles.topo}>
          <Text style={{ textAlign: "center" }}>
            Todos os seus contatos estão aqui
          </Text>
          <View>
            <SwipeListView
              data={data}
              renderItem={ItemLista}
              renderHiddenItem={BackitemLista}
              leftOpenValue={80}
              rightOpenValue={-72}
              keyExtractor={item => item.id}
              style={{ height: "100%" }}
              refreshControl={
                <RefreshControl refreshing={busy} onRefresh={() => { atualizarLista(true) }} />
              }
            />
          </View>
        </View>
      </SafeAreaView>
    )
  }

  const closeRow = (rowMap, rowKey) => {
    if (rowMap[rowKey]) {
      rowMap[rowKey].closeRow();
    }
  };

  const ItemLista = (data, rowMap) => {
    return (
      <View style={{ flex: 1, justifyContent: 'center' }}>
        <Pressable style={({ pressed }) => [
          {
            backgroundColor: pressed ? "#ccc" : "#fff",
          },
          localStyles.itemDestaque,
        ]}
          onPress={() => { closeRow(rowMap, data.item.id) }}
        >
          <View style={{ width: "100%" }}>
            <Text style={{ textAlign: "center" }}>{data.item.name}</Text>
            <Text style={{ textAlign: "center" }}>{data.item.dateTravel}</Text>
          </View> </Pressable> </View>)
  }

  const BackitemLista = () => (
    <View style={localStyles.itemFundo}>
      <Button title="Excluir" status={{ left: 0 }} color="crimson" />
      <Button title="Editar" style={{ right: 0 }} color="steelblue" />
    </View>);

  const localStyles = StyleSheet.create({
    topo: {
      marginTop: 10,
      width: "100%"
    },
    itemDestaque: {
      alignItems: 'flex-start',
      borderBottomColor: '#ccc',
      borderBottomWidth: 1,
      justifyContent: 'center',
      height: 60,
      paddingLeft: 20
    },
    itemFundo: {
      alignItems: 'center',
      backgroundColor: '#fff',
      borderBottomColor: '#ccc',
      borderBottomWidth: 1,
      flex: 1,
      flexDirection: 'row',
      justifyContent: 'space-between',
      paddingHorizontal: 4,
    }
  });
}
