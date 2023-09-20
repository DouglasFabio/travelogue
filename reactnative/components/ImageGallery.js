import React, { useEffect, useState } from 'react';
import { View, TouchableOpacity, FlatList, Image } from 'react-native';
import ImageView from 'react-native-image-zoom-viewer';
import axios from 'axios';
import { EXPO_PUBLIC_API_URL_HTTP_I } from '../env';

export default function ImageGallery({ route }) {
  const [images, setImages] = useState([]);
  const [imageIndex, setImageIndex] = useState(0);
  const [isImageViewVisible, setIsImageViewVisible] = useState(false);

  let url = EXPO_PUBLIC_API_URL_HTTP_I +`/${route.params.id}`;

  

  useEffect(() => {
    axios.get(url)
      .then(response => {
        response.data.forEach(item => {
          let caminhos = item.midiaPath;
          if (caminhos) {
            const images = caminhos.split(',');
            setImages(images.map((image) => ({ url: image })));
          }
        });
      })
      .catch(error => console.error(error));
  }, [route.params.id]);

  return (
    <View>
      {isImageViewVisible && (
        <ImageView
          imageUrls={images}
          index={imageIndex}
          onSwipeDown={() => setIsImageViewVisible(false)}
          enableSwipeDown
        />
      )}
      <FlatList
        data={images}
        renderItem={({ item, index }) => (
          <TouchableOpacity onPress={() => {
            setImageIndex(index);
            setIsImageViewVisible(true);
          }}>
            <Image source={{ uri: item.url }} style={{ width: 100, height: 100 }} />
          </TouchableOpacity>
        )}
        keyExtractor={(item, index) => index.toString()}
        numColumns={3} // Define o número de colunas do grid
      />
    </View>
  );
}
