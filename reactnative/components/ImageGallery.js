import React from 'react';
import { FlatList, Image, View } from 'react-native';
import Carousel from 'react-native-snap-carousel';

export default function ImageGallery({ images }) {
  const [activeIndex, setActiveIndex] = useState(0);

  const renderItem = ({ item }) => (
    <Image source={{ uri: item }} style={{ width: '100%', height: 200 }} />
  );

  return (
    <View>
      <Carousel
        data={images}
        renderItem={renderItem}
        sliderWidth={400}
        itemWidth={300}
        onSnapToItem={(index) => setActiveIndex(index)}
      />
      <FlatList
        data={images}
        horizontal
        renderItem={({ item, index }) => (
          <TouchableOpacity onPress={() => setActiveIndex(index)}>
            <Image source={{ uri: item }} style={{ width: 50, height: 50 }} />
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
