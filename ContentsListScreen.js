import React from 'react';
import {
  SafeAreaView,
  StyleSheet,
  View,
  Text,
  FlatList,
  StatusBar,
  TouchableOpacity,
} from 'react-native';
import jsonData from './data.json';

class ContentsListScreen extends React.Component {
  render() {
    return (
      <SafeAreaView style={styles.container}>
        {/* 一覧表示 */}
        <FlatList
          data={jsonData}
          keyExtractor={item => item.id}
          renderItem={({item}) => (
            <TouchableOpacity onPress={() => this.handleItemClick(item)}>
              <View style={styles.item}>
                <Text style={styles.title}>{item.url}</Text>
              </View>
            </TouchableOpacity>
          )}
        />
      </SafeAreaView>
    );
  }

  handleItemClick = item => {
    //itemをVideoPlayerScreenへ渡す
    this.props.navigation.navigate('VideoPlayer', item);
  };
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: StatusBar.currentHeight || 0,
  },
  item: {
    backgroundColor: '#dbdbdb',
    padding: 20,
    marginVertical: 8,
    marginHorizontal: 16,
  },
  title: {
    fontSize: 16,
  },
});

export default ContentsListScreen;
