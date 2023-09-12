// @flow
import React from "react";
import { Button, TextInput } from "react-native-paper";
import { DatePickerInput } from "react-native-paper-dates";
import { Colors } from "react-native/Libraries/NewAppScreen";

export default function TravelEdit(){
    
    <>
      <TextInput
        label={'Nome'}
        //error={errors?.nome}
        placeholder={'Digite o nome da viagem'}
        onChangeText={text => setValue('nome', text)}
      />
      <DatePickerInput
          locale="pt-br"
          label={'Data'}
          value={''}
          onChange={text => setValue('data', text)}
          inputMode="start"
        />
        <Button icon="send" mode="contained" onPress={() => postTravel()}>
            Cadastrar
        </Button>
    </>
}

