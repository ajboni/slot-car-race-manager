import React, { useState } from 'react';
import sm_1 from '../../../../src/img/SM/sm_01_idle.png'
import sm_2 from '../../../../src/img/SM/sm_02_countdown.png'
import sm_3 from '../../../../src/img/SM/sm_02b_false_start.png'
import sm_4 from '../../../../src/img/SM/sm_03_started.png'
import sm_5 from '../../../../src/img/SM/sm_04_finished.png'
import store from '../../../store'
import { observer } from 'mobx-react';

const StateMachine = observer(() => {
    let x = store.config;    
    const status = store.appState.RACE.status;
    console.log(status)

    function getImage() {
        switch (status) {
            case store.config.STATUS_IDLE:
                return sm_1;             
            case store.config.STATUS_COUNTDOWN:
                return sm_2;                 
            default:
                return sm_1;
                break;
        }
        
    }

 

    return (
        <div>
            <h2>State Machine  {status}</h2>
           
        <img src={getImage()} alt=""/>
        </div>
    )
});

export default StateMachine;