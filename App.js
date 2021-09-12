import 'react-native-gesture-handler';
import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import ContentsListScreen from './ContentsListScreen';
import VideoPlayerScreen from './VideoPlayerScreen';

const Stack = createNativeStackNavigator();

class App extends React.Component {
  render() {
    return (
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="ContentsList" component={ContentsListScreen} />
          <Stack.Screen name="VideoPlayer" component={VideoPlayerScreen}  options={{headerBackTitleVisible: false}} />
        </Stack.Navigator>
      </NavigationContainer>
    );
  }
}

export default App;
