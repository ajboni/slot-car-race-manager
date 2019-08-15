import React from "react";
import * as c from "../constants/constants";
import { observer } from "mobx-react";
import MaterialTable from "material-table";

import AddBox from "@material-ui/icons/AddBox";
import ArrowUpward from "@material-ui/icons/ArrowUpward";
import Check from "@material-ui/icons/Check";
import ChevronLeft from "@material-ui/icons/ChevronLeft";
import ChevronRight from "@material-ui/icons/ChevronRight";
import Clear from "@material-ui/icons/Clear";
import DeleteOutline from "@material-ui/icons/DeleteOutline";
import Edit from "@material-ui/icons/Edit";
import FilterList from "@material-ui/icons/FilterList";
import FirstPage from "@material-ui/icons/FirstPage";
import LastPage from "@material-ui/icons/LastPage";
import Remove from "@material-ui/icons/Remove";
import SaveAlt from "@material-ui/icons/SaveAlt";
import Search from "@material-ui/icons/Search";
import ViewColumn from "@material-ui/icons/ViewColumn";
import { forwardRef } from "react";
import l from "../constants/lang";
import store from "../store";

const tableIcons = {
  Add: forwardRef((props, ref) => <AddBox {...props} ref={ref} />),
  Check: forwardRef((props, ref) => <Check {...props} ref={ref} />),
  Clear: forwardRef((props, ref) => <Clear {...props} ref={ref} />),
  Delete: forwardRef((props, ref) => <DeleteOutline {...props} ref={ref} />),
  DetailPanel: forwardRef((props, ref) => (
    <ChevronRight {...props} ref={ref} />
  )),
  Edit: forwardRef((props, ref) => <Edit {...props} ref={ref} />),
  Export: forwardRef((props, ref) => <SaveAlt {...props} ref={ref} />),
  Filter: forwardRef((props, ref) => <FilterList {...props} ref={ref} />),
  FirstPage: forwardRef((props, ref) => <FirstPage {...props} ref={ref} />),
  LastPage: forwardRef((props, ref) => <LastPage {...props} ref={ref} />),
  NextPage: forwardRef((props, ref) => <ChevronRight {...props} ref={ref} />),
  PreviousPage: forwardRef((props, ref) => (
    <ChevronLeft {...props} ref={ref} />
  )),
  ResetSearch: forwardRef((props, ref) => <Clear {...props} ref={ref} />),
  Search: forwardRef((props, ref) => <Search {...props} ref={ref} />),
  SortArrow: forwardRef((props, ref) => <ArrowUpward {...props} ref={ref} />),
  ThirdStateCheck: forwardRef((props, ref) => <Remove {...props} ref={ref} />),
  ViewColumn: forwardRef((props, ref) => <ViewColumn {...props} ref={ref} />)
};

const DataTable = observer(({ data, columns, title, actions }) => {
  const localization = {
    body: {
      emptyDataSourceMessage: l.EMPTY_DATASOURCE_MESSAGE
    },
    toolbar: {
      searchTooltip: l.SEARCH,
      searchPlaceholder: l.SEARCH
    },
    header: {
      actions: l.ACTIONS
    }
  };

  return (
    <MaterialTable
      columns={columns}
      data={data}
      title={title}
      icons={tableIcons}
      actions={actions}
      localization={localization}
      options={{ toolbarButtonAlignment: "left", pageSize: 10 }}
    />
  );
});

export default DataTable;

export function getAction(collection) {
  return [
    {
      icon: "edit",
      tooltip: l["EDIT_" + collection],
      onClick: (event, rowData) => {
        store.setSelectedItem(collection, rowData);
        store.setOpenModal(collection, true);
        // racers_store.openModal(true);
        console.log(collection);
      }
    },
    {
      icon: "delete",
      tooltip: l["DELETE_" + collection],
      onClick: (event, item) => {
        let name = item.name ? item.name : item.id;
        const confirmDeletion = confirm(
          l.CONFIRM_DELETE + " " + l[collection] + " " + item.name + " ?"
        );

        if (confirmDeletion) {
          store.deleteItem({ variables: { id: item.id } });
        }
      }
    }
  ];
}
