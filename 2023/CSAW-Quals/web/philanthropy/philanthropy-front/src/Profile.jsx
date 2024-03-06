//import React from "react";
import { makeStyles } from "@mui/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";
import Input from "@mui/material/Input";
import Paper from "@mui/material/Paper";
import IconButton from "@mui/material/IconButton";
// Icons
import EditIcon from "@mui/icons-material/EditOutlined";
import DoneIcon from "@mui/icons-material/DoneAllTwoTone";
import RevertIcon from "@mui/icons-material/NotInterestedOutlined";

import React, { useState, useEffect } from 'react';
import axios from 'axios';


const useStyles = makeStyles((theme) => ({
  root: {
    width: "100%",
    marginTop: theme.spacing(3),
    overflowX: "auto"
  },
  table: {
    minWidth: 650
  },
  selectTableCell: {
    width: 60
  },
  tableCell: {
    width: 130,
    height: 40
  },
  input: {
    width: 130,
    height: 40
  }
}));

const createData = (name, value) => ({
  id: name.replace(" ", "_"),
  name,
  value,
  isEditMode: false
});

const CustomTableCell = ({ row, name, onChange }) => {
  const classes = useStyles();
  const { isEditMode } = row;
  return (
    <TableCell align="left" className={classes.tableCell}>
      {isEditMode ? (
        <Input
          value={row[name]}
          name={name}
          onChange={(e) => onChange(e, row)}
          className={classes.input}
        />
      ) : (
        row[name]
      )}
    </TableCell>
  );
};


export default function Profile() {

  const [data, setData] = useState({});
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    axios.get('/identity/account')
      .then(response => {
        const responseData = response.data;
        setData(responseData.msg);
        setIsLoading(false);
      })
      .catch(error => {
        setIsLoading(false);
      });
  }, []);

  const [rows, setRows] = React.useState([
      createData("Email", "default"),
      createData("First Name", "default"),
      createData("Last Name", "default")
  ]);

  const [previous, setPrevious] = React.useState({});
  const classes = useStyles();

  useEffect(() => {
    if (!isLoading) {
      setRows([createData("Email", data.username),
      createData("First Name", data.first_name),
      createData("Last Name", data.last_name)])
    }
  }, [isLoading, data]);

  const onToggleEditMode = (id) => {
    console.log(rows)

    const jsonPayload = {};

    const keyMap = {
      "Email": "username",
      "First Name": "first_name",
      "Last Name": "last_name"
    };

    rows.forEach(item => {
      const newKey = keyMap[item.name] || item.name;
      jsonPayload[newKey] = item.value;
    });
    console.log(jsonPayload)

    axios.post('/identity/update', jsonPayload, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
      .then(response => {
        const responseData = response.data;
        console.log(responseData);
      })
      .catch(error => {
        console.log(error.response.data.msg)
      });

    setRows((state) => {
      return rows.map((row) => {
        if (row.id === id) {
          return { ...row, isEditMode: !row.isEditMode };
        }
        return row;
      });
    });
  };

  const onChange = (e, row) => {
    if (!previous[row.id]) {
      setPrevious((state) => ({ ...state, [row.id]: row }));
    }
    const value = e.target.value;
    const name = e.target.name;
    const { id } = row;
    const newRows = rows.map((row) => {
      if (row.id === id) {
        return { ...row, [name]: value };
      }
      return row;
    });
    setRows(newRows);
  };

  const onRevert = (id) => {
    const newRows = rows.map((row) => {
      if (row.id === id) {
        return previous[id] ? previous[id] : row;
      }
      return row;
    });
    setRows(newRows);
    setPrevious((state) => {
      delete state[id];
      return state;
    });
    onToggleEditMode(id);
  };

  return (
    <Paper className={classes.root}>
      <Table className={classes.table} aria-label="caption table">
        <TableBody>
          
          {rows.map((row) => (
            <TableRow key={row.id}>
              <TableCell className={classes.selectTableCell}>
                {row["id"] != "Email" ? (
                  row.isEditMode ? (
                    <>
                      <IconButton
                        aria-label="done"
                        onClick={() => onToggleEditMode(row.id)}
                      >
                        <DoneIcon />
                      </IconButton>
                      <IconButton
                        aria-label="revert"
                        onClick={() => onRevert(row.id)}
                      >
                        <RevertIcon />
                      </IconButton>
                    </>
                  ) : (
                    <IconButton
                      aria-label="delete"
                      onClick={() => onToggleEditMode(row.id)}
                    >
                      <EditIcon />
                    </IconButton>
                  )
                ) : ""}

              </TableCell>
              <TableCell align="left" className={classes.tableCell}>
                {row["id"]}
              </TableCell>
              {row["id"] == "Email" ? (
                <TableCell>{row["value"]}</TableCell>
              ):(
              <CustomTableCell {...{ row, name: "value", onChange }} />
              )}
                
                           
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Paper>
  );
}
