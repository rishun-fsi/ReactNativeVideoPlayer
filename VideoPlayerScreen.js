import React from 'react';
import {
  StyleSheet,
  View,
  Text,
  Image,
  Alert,
  TouchableOpacity,
  Dimensions,
  NativeModules,
  requireNativeComponent,
} from 'react-native';

const windowWidth = Dimensions.get('window').width;

const {PlayControllerModule} = NativeModules;

const NativeVideoView = requireNativeComponent('NativeVideoView');

class VideoPlayerScreen extends React.Component {
  constructor(props) {
    super(props);

    this.timerID = null;
    this.timeCount = 0;
    this.state = {
      currentTime: '00:00:00',
      totalTime: '00:00:00',
      isPlaying: true,
      uri: require('./images/play-button.png'),
      visibilityController: false,
    };
  }

  createAlert = (title, message) =>
    Alert.alert(title, message, [
      {
        text: 'Close',
        onPress: () => this.props.navigation.navigate('ContentsList'),
      },
    ]);

  changeIcon() {
    this.showController();
    if (this.state.isPlaying) {
      this.setState({
        isPlaying: false,
        uri: require('./images/pause-button.png'),
      });
      PlayControllerModule.sendPlayControllerEvent('pause');
    } else {
      this.setState({
        isPlaying: true,
        uri: require('./images/play-button.png'),
      });
      PlayControllerModule.sendPlayControllerEvent('play');
    }
  }

  seek(isFastForward) {
    this.showController();
    if (isFastForward) {
      PlayControllerModule.sendPlayControllerEvent('fast_forward');
    } else {
      PlayControllerModule.sendPlayControllerEvent('fast_backward');
    }
  }

  showController() {
    this.setState({
      visibilityController: true,
    });
    this.timeCount = 0;
  }

  componentDidMount() {
    this.timerID = setInterval(() => {
      //console.log('I do not leak');
      if (this.timeCount > 5) {
        this.setState({
          visibilityController: false,
        });
        this.timeCount = 0;
      }
      this.timeCount++;
      PlayControllerModule.createPlayControllerEvent(
        'test-key',
        'test-value',
        eventId => {
          //console.log(`Created a new event with id ${eventId}`);

          this.setState({currentTime: `${secondsToTime(eventId)}`});
        },
      );
      //this.setState({ lastRefresh: Date(Date.now()).toString() })
    }, 1000);
  }

  /**
   * Frees up timer if it is set.
   */
  componentWillUnmount() {
    if (this.timerID != null) {
      clearInterval(this.timerID);
    }
  }

  render() {
    //ContentsListScreenから渡されたitemを受け取る
    const item = this.props.route.params;

    return (
      <TouchableOpacity
        style={styles.container}
        onPress={() => this.showController()}>
        <NativeVideoView
          value={item.url}
          style={{
            width: windowWidth,
            height: (windowWidth * 9) / 16,
            backgroundColor: 'black',
          }}
          // onChange={event => console.log(event.nativeEvent.duration)}
          onChange={event => {
            this.setState({
              totalTime: `${secondsToTime(event.nativeEvent.duration)}`,
            });
            this.showController();
          }}
          onError={event => this.createAlert("Error", event.nativeEvent.error)}
        />
        {this.state.visibilityController && (
          <View style={styles.playerControllerArea}>
            <View style={styles.playControlStyle}>
              <TouchableOpacity
                style={styles.playButtonStyle}
                activeOpacity={0.5}
                onPress={() => this.seek(false)}>
                <Image
                  source={require('./images/fast-backward.png')}
                  style={styles.playImageIconStyle}
                />
              </TouchableOpacity>
              <TouchableOpacity
                style={styles.playButtonStyle}
                activeOpacity={0.5}
                onPress={() => this.changeIcon()}>
                <Image
                  source={this.state.uri}
                  style={styles.playImageIconStyle}
                />
              </TouchableOpacity>
              <TouchableOpacity
                style={styles.playButtonStyle}
                activeOpacity={0.5}
                onPress={() => this.seek(true)}>
                <Image
                  source={require('./images/fast-forward.png')}
                  style={styles.playImageIconStyle}
                />
              </TouchableOpacity>
            </View>
            <View style={styles.timerArea}>
              <Text style={styles.currentArea}>{this.state.currentTime}</Text>
              <Text style={styles.durantionArea}>{this.state.totalTime}</Text>
            </View>
          </View>
        )}
      </TouchableOpacity>
    );
  }
}

function secondsToTime(seconds) {
  var hour = Math.floor(seconds / 3600);
  var minute = Math.floor((seconds % 3600) / 60);
  var second = Math.floor(seconds % 60);

  if (hour < 10) {
    hour = '0' + hour;
  }
  if (minute < 10) {
    minute = '0' + minute;
  }
  if (second < 10) {
    second = '0' + second;
  }
  return hour + ':' + minute + ':' + second;
}

const styles = StyleSheet.create({
  container: {
    width: windowWidth,
    height: (windowWidth * 9) / 16,
  },
  playerControllerArea: {
    flex: 1,
    position: 'absolute',
  },
  timerArea: {
    position: 'absolute',
    top: (windowWidth * 9) / 16 - 20,
    flexDirection: 'row',
  },
  currentArea: {
    flex: 1,
    fontSize: 16,
    color: '#f5f5f5',
  },
  durantionArea: {
    flex: 1,
    textAlign: 'right',
    fontSize: 16,
    color: '#f5f5f5',
  },
  playControlStyle: {
    width: windowWidth,
    height: (windowWidth * 9) / 16,
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
  },
  playButtonStyle: {
    alignItems: 'center',
  },
  playImageIconStyle: {
    height: 48,
    width: 48,
    // resizeMode: 'stretch',
  },
});

export default VideoPlayerScreen;
