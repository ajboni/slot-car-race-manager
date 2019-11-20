import store from "../../../store";
import { observer } from "mobx-react";
import React, { useEffect } from 'react';



const RaceClock = observer(() => {

    // useEffect(() => {
    //     const timer = setInterval(() => {
    //         store.getRaceTime()
    //     }, store.config.CLOCK_SYNC_TIME);
    // }, []);

    return (
        <h1>{store.appState.RACE.currentTime} </h1>
    )

});

export default RaceClock;