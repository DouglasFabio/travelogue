// @flow
import React from "react";
import { Button, TextInput } from "react-native-paper";
import { DatePickerInput } from "react-native-paper-dates";

export default function EntryForm(){
    
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

