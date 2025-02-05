import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, TextInput, View } from 'react-native';
import { useState } from 'react';

export default function App() {
  const [input, setInput] = useState('');

  return (
    <View style={styles.container}>
      <View style={styles.calculatorContainer}>
        <TextInput
          style={styles.input}
          value={input}
          editable={false}
        />
        <View style={styles.row}>
          <View style={styles.buttonContainer}><Text style={styles.specialButton}>AC</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.specialButton}>CE</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>%</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>/</Text></View>
        </View>
        <View style={styles.row}>
          <View style={styles.buttonContainer}><Text style={styles.button}>7</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>8</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>9</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>*</Text></View>
        </View>
        <View style={styles.row}>
          <View style={styles.buttonContainer}><Text style={styles.button}>4</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>5</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>6</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>-</Text></View>
        </View>
        <View style={styles.row}>
          <View style={styles.buttonContainer}><Text style={styles.button}>1</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>2</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>3</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>+</Text></View>
        </View>
        <View style={styles.row}>
          <View style={styles.buttonContainer}><Text style={styles.button}>0</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>.</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>=</Text></View>
          <View style={styles.buttonContainer}><Text style={styles.button}>:)</Text></View>
        </View>
      </View>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  specialButton: {
    fontSize: 23,
    padding: 10,
    backgroundColor: 'orange',
    textAlign: 'center',
    width: 50,
    height: 45,
  },
  calculatorContainer: {
    borderWidth: 2,
    borderColor: '#000',
    padding: 10,
    backgroundColor: '#eee',
    borderRadius: 10,
  },
  input: {
    fontSize: 32,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: '#000',
    backgroundColor: '#e3fcd9',
    padding: 45,
    width: '100%',
    textAlign: 'right',
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 2,
  },
  buttonContainer: {
    margin: 5,
    borderWidth: 1,
    borderColor: '#000',
    borderRadius: 5,
    overflow: 'hidden',
  },
  button: {
    fontSize: 24,
    padding: 10,
    backgroundColor: '#9fa09f',
    textAlign: 'center',
    width: 50,
    height: 45,
  },
  buttonLarge: {
    fontSize: 24,
    padding: 10,
    backgroundColor: '#ddd',
    textAlign: 'center',
    width: 50, 
    height: 90
  },
});