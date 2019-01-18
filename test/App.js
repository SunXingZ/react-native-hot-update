/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Image, TouchableOpacity, Alert } from 'react-native';
import RNHotupdate from 'react-native-hot-update';

type Props = {};
export default class App extends Component<Props> {

  componentDidMount() {}

  updateJSBundle() {
    const serverJSBundle = "your server jsbundle download address/main.jsbundle.zip";
    RNHotupdate.downloadJSBundleFromServer(serverJSBundle, (result) => {
      if (result) {
        Alert.alert(
          "提示",
          "更新完成是否重新加载？",
          [
            {
              text: "更新",
              onPress: () => {
                RNHotupdate.reloadJSBundle();
              }
            },
          ]
        )
      }
    });
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.updateJSBundle.bind(this)}>
          <Text style={styles.welcome}>检查更新</Text>
        </TouchableOpacity>
        <Image source={require("./icon/alipay.png")} style={{ width: 50, height: 50 }} />
        <Image source={require("./icon/wechat.png")} style={{ width: 50, height: 50 }} />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    color: "#666666",
    textAlign: 'center',
    margin: 10,
  },
});
