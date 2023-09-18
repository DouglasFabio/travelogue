import React, { useEffect, useState } from 'react';
import { View, Image } from 'react-native';
import * as ImagePicker from 'expo-image-picker';
import { Button } from 'react-native-paper';
import axios from 'axios';

export default function ImageGallery({ route }) {
  const [images, setImages] = useState([]);

  let url = `http://10.0.2.2:5000/api/Imagem/${route.params.id}`;
  console.log(route.params.id);

  useEffect(() => {
    axios.get(url)
      .then(response => {
        let midiaPath = response.data.midiaPath;
        console.log(response.data);
        if (midiaPath) {
          const images = midiaPath.split(',');
          setImages(images);
        }
      })
      .catch(error => console.error(error));

  }, [route.params.id]);

  const pickImage = async () => {
    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      allowsEditing: true,
      aspect: [4, 3],
      quality: 1,
    });

    if (!result.cancelled) {
      setImages([...images, result.uri]);
    }
  };

  return (
    <View>
      {images.map((image, index) => (
        <Image key={index} source={{ uri: image }} style={{ width: 200, height: 200 }} />
      ))}
      <Button title="Pick an image from gallery" onPress={pickImage} />
    </View>
  );
}
