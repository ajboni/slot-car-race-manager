import React from 'react'
import { observer } from 'mobx-react';
import { makeStyles } from '@material-ui/styles';
import { Paper } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
    root: {
        padding: theme.spacing(3, 2)
    },
}));

const RaceLive = observer(() => {
    const classes = useStyles();

    return (

        <h1>RACE LIVE</h1>
    );
});

export default RaceLive;
