import Toast from 'react-native-toast-message';

export default async function getData(url) {
    try {
        const response = await fetch(url);
        const data = await response.json();
        return data;
    } catch (e) {
        Toast.show({
            type: 'error',
            text1: 'Erro',
            text2: 'Houve um erro ao buscar os dados',
            position: 'bottom'
        });
    }
}