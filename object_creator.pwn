/*
 * Module Name: object_creator
 * Created by: Lukman
 * Created on: 18 March 2021
 *
**/


/*
 * PREREQUISITE INCLUDES
 *
**/
#include <a_samp>
#include <streamer>

#include <YSI\y_hooks>
#include <YSI\y_iterate>

#include "alltextures.pwn"

/*
 * DEFINE
 *
**/

#define MAX_MATERIALS (16)
#define MAX_OBJ (5000)

/*
 * ENUM
 *
**/

enum objData {
  oID,
  oModel,
  Float:oPos[3],
  Float:oRot[3],
  oVw,
  oInt,
  Float:oStream,
  oMaterials[MAX_MATERIALS],
  oMatsColor[MAX_MATERIALS],
  oMatsText,
  oMatsTextIndex,
  oText[256],
  oMatsTextSize,
  oMatsTextFont[32],
  oMatsTextFontSize,
  oMatsTextBold,
  oMatsTextColor,
  oMatsTextBackColor,
  oMatsTextAlignment,
  oObject
};
new ObjData[MAX_OBJ][objData],
    Iterator:Obj<MAX_OBJ>;
    
new PlayerEditObject[MAX_PLAYERS] = {-1, ...};

// Variable
new const WinFonts[15][20] = {
  {"Arial"},
  {"Calibri"},
  {"Comic Sans MS"},
  {"Georgia"},
  {"Times New Roman"},
  {"Consolas"},
  {"Constantia"},
  {"Corbel"},
  {"Courier New"},
  {"Impact"},
  {"Lucida Console"},
  {"Palatino Linotype"},
  {"Tahoma"},
  {"Trebuchet MS"},
  {"Verdana"}
};

new const TextResolution[][] = {
  "32x32",
  "64x32",
  "64x64",
  "128x32",
  "128x64",
  "128x128",
  "256x32",
  "256x64",
  "256x128",
  "256x256",
  "512x64",
  "512x128",
  "512x256",
  "512x512"
};

/*
 * ALL HOOKS
 *
**/

hook OnGameModeInitEx() {
  mysql_pquery(g_iHandle, "SELECT * FROM `objects`", "Object_Load", "");
}

hook OnGameModeExit() {
  foreach (new i : Obj) {
    Object_Save(i);
  }
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
  if (PlayerEditObject[playerid] != -1) {
    switch(response) {
      case EDIT_RESPONSE_CANCEL: {
        SetDynamicObjectPos(objectid, x, y, z);
	SetDynamicObjectRot(objectid, rx, ry, rz);
      }
      case EDIT_RESPONSE_FINAL: {
      	new id = PlayerEditObject[playerid];
 	SetDynamicObjectPos(objectid, x, y, z);
	SetDynamicObjectRot(objectid, rx, ry, rz);
	ObjData[id][oPos][0] = x;
	ObjData[id][oPos][1] = y;
	ObjData[id][oPos][2] = z;
	ObjData[id][oRot][0] = rx;
	ObjData[id][oRot][1] = ry;
	ObjData[id][oRot][2] = rz;
	Object_Refresh(id);
	Object_Save(id);
      }
    }
  }
  return 1;
}

hook OnPlayerConnect(playerid) {
  PlayerEditObject[playerid] = -1;
}

/*
 * ALL CALLBACKS
 *
**/

Function:onObjectCreated(id) {
  if (!Iter_Contains(Obj, id))
    return 0;

  ObjData[id][oID] = cache_insert_id();
  Object_Save(id);
  return 1;
}

Function:Object_Load() {
  new rows = cache_num_rows(), string[32];
  if (rows) {
    for (new i = 0; i < rows; i ++) {
      Iter_Add(Obj, i);

      cache_get_value_int(i, "ID", ObjData[i][oID]);
      cache_get_value_int(i, "Model", ObjData[i][oModel]);
      cache_get_value_float(i, "X", ObjData[i][oPos][0]);
      cache_get_value_float(i, "Y", ObjData[i][oPos][1]);
      cache_get_value_float(i, "Z", ObjData[i][oPos][2]);
      cache_get_value_float(i, "RotX", ObjData[i][oRot][0]);
      cache_get_value_float(i, "RotY", ObjData[i][oRot][1]);
      cache_get_value_float(i, "RotZ", ObjData[i][oRot][2]);
      cache_get_value_int(i, "Vw", ObjData[i][oVw]);
      cache_get_value_int(i, "Int", ObjData[i][oInt]);
      cache_get_value_float(i, "Stream", ObjData[i][oStream]);
      
      cache_get_value(i, "Materials", string);
      sscanf(string, "p<|>dddddddddddddddd", ObjData[i][oMaterials][0], ObjData[i][oMaterials][1], ObjData[i][oMaterials][2], ObjData[i][oMaterials][3], ObjData[i][oMaterials][4], ObjData[i][oMaterials][5], ObjData[i][oMaterials][6], ObjData[i][oMaterials][7], ObjData[i][oMaterials][8], ObjData[i][oMaterials][9], ObjData[i][oMaterials][10], ObjData[i][oMaterials][11], ObjData[i][oMaterials][12], ObjData[i][oMaterials][13], ObjData[i][oMaterials][14], ObjData[i][oMaterials][15]);

      cache_get_value(i, "MatsColor", string);
      sscanf(string, "p<|>dddddddddddddddd", ObjData[i][oMatsColor][0], ObjData[i][oMatsColor][1], ObjData[i][oMatsColor][2], ObjData[i][oMatsColor][3], ObjData[i][oMatsColor][4], ObjData[i][oMatsColor][5], ObjData[i][oMatsColor][6], ObjData[i][oMatsColor][7], ObjData[i][oMatsColor][8], ObjData[i][oMatsColor][9], ObjData[i][oMatsColor][10], ObjData[i][oMatsColor][11], ObjData[i][oMatsColor][12], ObjData[i][oMatsColor][13], ObjData[i][oMatsColor][14], ObjData[i][oMatsColor][15]);

      cache_get_value_int(i, "MatsText", ObjData[i][oMatsText]);
      cache_get_value_int(i, "MatsTextIndex", ObjData[i][oMatsTextIndex]);
      cache_get_value(i, "Text", ObjData[i][oText], 256);
      cache_get_value_int(i, "MatsTextSize", ObjData[i][oMatsTextSize]);
      cache_get_value(i, "MatsTextFont", ObjData[i][oMatsTextFont], 32);
      cache_get_value_int(i, "MatsTextFontSize", ObjData[i][oMatsTextFontSize]);
      cache_get_value_int(i, "MatsTextBold", ObjData[i][oMatsTextBold]);
      cache_get_value_int(i, "MatsTextColor", ObjData[i][oMatsTextColor]);
      cache_get_value_int(i, "MatsTextBackColor", ObjData[i][oMatsTextBackColor]);
      cache_get_value_int(i, "MatsTextAlignment", ObjData[i][oMatsTextAlignment]);

      Object_Refresh(i);
    }
  }
  printf("*** [load] object data loaded (%d count)", rows);
  return 1;
}

/*
 * ALL FUNCTIONS
 *
**/

Object_Create(model, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, vw = -1, int = -1, Float:dd = 300.0) {
  new i = INVALID_ITERATOR_SLOT;

  if ((i = Iter_Free(Obj)) != INVALID_ITERATOR_SLOT) {
    Iter_Add(Obj, i);

    ObjData[i][oModel] = model;
    ObjData[i][oPos][0] = x;
    ObjData[i][oPos][1] = y;
    ObjData[i][oPos][2] = z;
    ObjData[i][oRot][0] = rx;
    ObjData[i][oRot][1] = ry;
    ObjData[i][oRot][2] = rz;
    ObjData[i][oVw] = vw;
    ObjData[i][oInt] = int;
    ObjData[i][oStream] = dd;
    for (new j = 0; j < MAX_MATERIALS; j ++) {
      ObjData[i][oMaterials][j] = 0;
      ObjData[i][oMatsColor][j] = 0;
    }
    ObjData[i][oMatsText] = 0;
    ObjData[i][oMatsTextIndex] = 0;
    new text[256];
    format(text,sizeof(text),"Text Here");
    FixText(text);
    format(ObjData[i][oText], 256, text);
    ObjData[i][oMatsTextSize] = OBJECT_MATERIAL_SIZE_256x128;
    format(ObjData[i][oMatsTextFont], 32, "Arial");
    ObjData[i][oMatsTextFontSize] = 24;
    ObjData[i][oMatsTextBold] = 1;
    ObjData[i][oMatsTextColor] = 0xFFFFFFFF;
    ObjData[i][oMatsTextBackColor] = 0xFF000000;
    ObjData[i][oMatsTextAlignment] = 0;

    Object_Refresh(i);

    mysql_tquery(g_iHandle, sprintf("INSERT INTO `objects` (`Model`) VALUES ('%d')", model), "onObjectCreated", "d", i);

    return i;
  }
  return INVALID_ITERATOR_SLOT;
}

Object_Save(id) {
  new query[2024];

  format(query, sizeof(query), "UPDATE `objects` SET `Model` = '%d', `X` = '%f', `Y` = '%f', `Z` = '%f', `RotX` = '%f', `RotY` = '%f', `RotZ` = '%f', `Vw` = '%d', `Int` = '%d', `Stream` = '%.1f', `Materials`='%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d', `MatsColor`='%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'",
    ObjData[id][oModel],
    ObjData[id][oPos][0],
    ObjData[id][oPos][1],
    ObjData[id][oPos][2],
    ObjData[id][oRot][0],
    ObjData[id][oRot][1],
    ObjData[id][oRot][2],
    ObjData[id][oVw],
    ObjData[id][oInt],
    ObjData[id][oStream],
    ObjData[id][oMaterials][0],
    ObjData[id][oMaterials][1],
    ObjData[id][oMaterials][2],
    ObjData[id][oMaterials][3],
    ObjData[id][oMaterials][4],
    ObjData[id][oMaterials][5],
    ObjData[id][oMaterials][6],
    ObjData[id][oMaterials][7],
    ObjData[id][oMaterials][8],
    ObjData[id][oMaterials][9],
    ObjData[id][oMaterials][10],
    ObjData[id][oMaterials][11],
    ObjData[id][oMaterials][12],
    ObjData[id][oMaterials][13],
    ObjData[id][oMaterials][14],
    ObjData[id][oMaterials][15],
    ObjData[id][oMatsColor][0],
    ObjData[id][oMatsColor][1],
    ObjData[id][oMatsColor][2],
    ObjData[id][oMatsColor][3],
    ObjData[id][oMatsColor][4],
    ObjData[id][oMatsColor][5],
    ObjData[id][oMatsColor][6],
    ObjData[id][oMatsColor][7],
    ObjData[id][oMatsColor][8],
    ObjData[id][oMatsColor][9],
    ObjData[id][oMatsColor][10],
    ObjData[id][oMatsColor][11],
    ObjData[id][oMatsColor][12],
    ObjData[id][oMatsColor][13],
    ObjData[id][oMatsColor][14],
    ObjData[id][oMatsColor][15],
    ObjData[id][oID]
  );
  mysql_tquery(g_iHandle, query);
  format(query,sizeof(query),"UPDATE `objects` SET `MatsText` = '%d', `MatsTextIndex` = '%d', `Text` = '%s', `MatsTextSize` = '%d', `MatsTextFont` = '%s', `MatsTextFontSize` = '%d', `MatsTextBold` = '%d', `MatsTextColor` = '%d', `MatsTextBackColor` = '%d', `MatsTextAlignment` = '%d' WHERE `ID` = '%d'",
    ObjData[id][oMatsText],
    ObjData[id][oMatsTextIndex],
    SQL_ReturnEscaped(ObjData[id][oText]),
    ObjData[id][oMatsTextSize],
    SQL_ReturnEscaped(ObjData[id][oMatsTextFont]),
    ObjData[id][oMatsTextFontSize],
    ObjData[id][oMatsTextBold],
    ObjData[id][oMatsTextColor],
    ObjData[id][oMatsTextBackColor],
    ObjData[id][oMatsTextAlignment],
    ObjData[id][oID]
  );
  mysql_tquery(g_iHandle, query);
  return 1;
}

Object_Refresh(id) {
  if (id != -1) {
    if (!IsValidDynamicObject(ObjData[id][oObject])) {
      ObjData[id][oObject] = CreateDynamicObject(ObjData[id][oModel], ObjData[id][oPos][0], ObjData[id][oPos][1], ObjData[id][oPos][2], ObjData[id][oRot][0], ObjData[id][oRot][1], ObjData[id][oRot][2], ObjData[id][oVw], ObjData[id][oInt], -1, STREAMER_OBJECT_SD, ObjData[id][oStream]);
    }
    Object_Update(id);
  }
  return 1;
}

Object_Update(id) {
  if (Iter_Contains(Obj, id)) {
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_X,ObjData[id][oPos][0]);
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_Y,ObjData[id][oPos][1]);
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_Z,ObjData[id][oPos][2]);
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_R_X,ObjData[id][oRot][0]);
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_R_Y,ObjData[id][oRot][1]);
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_R_Z,ObjData[id][oRot][2]);
    Streamer_SetIntData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_WORLD_ID,ObjData[id][oVw]);
    Streamer_SetIntData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_INTERIOR_ID,ObjData[id][oInt]);
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_DRAW_DISTANCE,ObjData[id][oStream]);

    for (new i = 0; i < MAX_MATERIALS; i ++) if (ObjData[id][oMaterials][i] > 0) {
      SetDynamicObjectMaterial(ObjData[id][oObject],i,GetTModel(ObjData[id][oMaterials][i]),GetTXDName(ObjData[id][oMaterials][i]),GetTextureName(ObjData[id][oMaterials][i]),ObjData[id][oMatsColor][i]);
    }

    if (ObjData[id][oMatsText]) {
      SetDynamicObjectMaterialText(ObjData[id][oObject],ObjData[id][oMatsTextIndex],ObjData[id][oText],ObjData[id][oMatsTextSize],ObjData[id][oMatsTextFont],ObjData[id][oMatsTextFontSize],ObjData[id][oMatsTextBold],ObjData[id][oMatsTextColor],ObjData[id][oMatsTextBackColor],ObjData[id][oMatsTextAlignment]);
    }
  }
  return 1;
}

Object_Delete(id) {
  if (Iter_Contains(Obj, id)) {
    mysql_tquery(g_iHandle, sprintf("DELETE FROM objects WHERE ID = '%d'", ObjData[id][oID]));

    DestroyDynamicObject(ObjData[id][oObject]);
    
    ObjData[id][oObject] = INVALID_STREAMER_ID;
    for (new x = 0; x < MAX_MATERIALS; x ++) {
      ObjData[id][oMaterials][x] = 0;
      ObjData[id][oMatsColor][x] = 0;
    }
    Iter_Remove(Obj, id);
    return 1;
  }
  return 0;
}

Object_Nearest(playerid) {
  new id = -1, Float: playerdist, Float: tempdist = 9999.0;
	
  foreach (new i : Obj)
  {
        playerdist = GetPlayerDistanceFromPoint(playerid, ObjData[i][oPos][0], ObjData[i][oPos][1], ObjData[i][oPos][2]);
        if(playerdist > 5.0) continue;
	    if(playerdist <= tempdist) {
	        tempdist = playerdist;
	        id = i;
	    }
	}
	
  return id;
}

/*
 * ALL COMMANDS
 *
**/

CMD:createobject(playerid, params[]) {
  if (CheckAdmin(playerid, 5))
    return PermissionError(playerid);

  new modelid;
  if (sscanf(params, "d", modelid))
    return SendSyntaxMessage(playerid, "/createobject [modelid]");

  new id, Float:x, Float:y, Float:z, Float:angle;
  GetPlayerPos(playerid, z, z, z);
  GetPlayerFacingAngle(playerid, angle);
  GetXYInFrontOfPlayer(playerid, x, y, 3.0);
  
  id = Object_Create(modelid, x, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

  if (id == INVALID_ITERATOR_SLOT) return SendErrorMessage(playerid, "The objects has reached the maximum!");
  SendCustomMessage(playerid, "OBJECT", "You've successfully created object id: "YELLOW"%d", id);
  Streamer_Update(playerid);
  return 1;
}

CMD:editobject(playerid, params[]) {
  if (CheckAdmin(playerid, 5))
    return PermissionError(playerid);

  new opt[64], value[128];
  if (sscanf(params, "s[64]S()[128]", opt, value)) {
    SendSyntaxMessage(playerid, "/editobject [option]");
    SendClientMessage(playerid, X11_YELLOW_2, "[OPTIONS]: "WHITE"position, fixpos, model, copy, gethere, material, resetmaterial, textprop, resettextprop, vw, int, drawdistance");
    return 1;
  }

  if (!strcmp(opt, "position")) {
    new id;
    if (sscanf(value, "d", id))
      return SendSyntaxMessage(playerid, "/editobject position [object id]");

    if (!Iter_Contains(Obj, id)) return SendErrorMessage(playerid, "Invalid object id!");

    PlayerEditObject[playerid] = id;
    EditDynamicObject(playerid, ObjData[id][oObject]);
    SendCustomMessage(playerid, "OBJECT", "You're now editing object id: "YELLOW"%d", id);
  } else if (!strcmp(opt, "fixpos")) {
    new id, Float:pos[6];
    if (sscanf(value, "dffffff", id, pos[0], pos[1], pos[2], pos[3], pos[4], pos[5]))
      return SendSyntaxMessage(playerid, "/editobject position [object id] [x] [y] [z] [rx] [ry] [rz]");

    if (!Iter_Contains(Obj, id)) return SendErrorMessage(playerid, "Invalid object id!");

    ObjData[id][oPos][0] = pos[0];
    ObjData[id][oPos][1] = pos[1];
    ObjData[id][oPos][2] = pos[2];
    ObjData[id][oRot][0] = pos[3];
    ObjData[id][oRot][1] = pos[4];
    ObjData[id][oRot][2] = pos[5];
    SetDynamicObjectPos(ObjData[id][oObject], pos[0], pos[1], pos[2]);
    SetDynamicObjectRot(ObjData[id][oObject], pos[3], pos[4], pos[5]);
    
    Object_Save(id);
    SendCustomMessage(playerid, "OBJECT", "You've changed fix position of object id: "YELLOW"%d", id);
  } else if (!strcmp(opt, "model")) {
    new id, newmodel;
    if (sscanf(value, "dd", id, newmodel))
      return SendSyntaxMessage(playerid, "/editobject model [object id] [modelid]");

    if (!Iter_Contains(Obj, id)) return SendErrorMessage(playerid, "Invalid object id!");
    ObjData[id][oModel] = newmodel;
    Object_Refresh(id);
    Object_Save(id);
    Streamer_Update(playerid);
    SendCustomMessage(playerid, "OBJECT", "You've changed model of object id: "YELLOW"%d", id);
  } else if (!strcmp(opt, "copy")) {
    new id;
    if (sscanf(value, "d", id))
      return SendSyntaxMessage(playerid, "/editobject copy [object id]");

    if (!Iter_Contains(Obj, id)) return SendErrorMessage(playerid, "Invalid object id!");

    new newobj, model, index, modelid, txdname[32], texture[32], color;
    new ind,text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
    new Float:position[3], Float:rotation[3], vw, int, Float:dd;
    model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, ObjData[id][oObject], E_STREAMER_MODEL_ID);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_X,position[0]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_Y,position[1]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_Z,position[2]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_R_X,rotation[0]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_R_Y,rotation[1]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_R_Z,rotation[2]);
    vw = Streamer_GetIntData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_WORLD_ID);
    int = Streamer_GetIntData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_INTERIOR_ID);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,ObjData[id][oObject],E_STREAMER_DRAW_DISTANCE,dd);
    newobj = Object_Create(model, position[0], position[1], position[2], rotation[0], rotation[1], rotation[2], vw, int, dd);

    if (newobj == cellmin) return SendErrorMessage(playerid, "Server has reached the maximum of Objects!");

    GetDynamicObjectMaterial(ObjData[id][oObject], index, modelid, txdname, texture, color);
    ObjData[newobj][oMaterials][index] = GetTextureIndex(modelid, txdname, texture);
    ObjData[newobj][oMatsColor][index] = color;

    if (ObjData[id][oMatsText]) {
      GetDynamicObjectMaterialText(ObjData[id][oObject],ind,text,size,font,fsize,bold,fcolor,bcolor,alignment);
      ObjData[newobj][oMatsTextIndex] = ind;
      FixText(text);
      format(ObjData[newobj][oText], 256, "%s", text);
      ObjData[newobj][oMatsTextSize] = size;
      format(ObjData[newobj][oMatsTextFont], 32, "%s", font);
      ObjData[newobj][oMatsTextFontSize] = fsize;
      ObjData[newobj][oMatsTextBold] = bold;
      ObjData[newobj][oMatsTextColor] = fcolor;
      ObjData[newobj][oMatsTextBackColor] = bcolor;
      ObjData[newobj][oMatsTextAlignment] = alignment;
    }
    Object_Refresh(newobj);
    Object_Save(newobj);
    Streamer_Update(playerid);
    SendCustomMessage(playerid, "OBJECT", "You've copied object id "YELLOW"%d "WHITE"to object id "YELLOW"%d", id, newobj);
  } else if (!strcmp(opt, "gethere")) {
    new id;
    if (sscanf(value, "d", id))
      return SendSyntaxMessage(playerid, "/editobject gethere [object id]");

    if (!Iter_Contains(Obj, id)) return SendErrorMessage(playerid, "Invalid object id!");

    new Float:pos[4];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    pos[0] += 1.0 * floatsin(-pos[3], degrees);
    pos[1] += 1.0 * floatcos(-pos[3], degrees);

    ObjData[id][oPos][0] = pos[0];
    ObjData[id][oPos][1] = pos[1];
    ObjData[id][oPos][2] = pos[2];
    ObjData[id][oRot][2] = pos[3];
    ObjData[id][oVw] = GetPlayerVirtualWorld(playerid);
    ObjData[id][oInt] = GetPlayerInterior(playerid);
    
    Object_Refresh(id);
    Object_Save(id);
    Streamer_Update(playerid);
    SendCustomMessage(playerid, "OBJECT", "You've been gethere object id "YELLOW"%d "WHITE"to you.", id);
  } else if (!strcmp(opt, "material")) {
    new slot,index,model,txdname[32],texture[32],color[4];

    if (sscanf(value,"ddds[32]s[32]D(0)D(0)D(0)D(0)",slot,index,model,txdname,texture,color[0],color[1],color[2],color[3]))
    return SendSyntaxMessage(playerid, "/editobject material [object id] [index] [model] [txdname] [texture] [opt: alpha] [opt: red] [opt: green] [opt: blue]");

    if (!Iter_Contains(Obj, slot))
    return SendErrorMessage(playerid, "Invalid object id!");

    if ((index > MAX_MATERIALS) || (index < 0))
    return SendErrorMessage(playerid,"index cannot go below 0 or over %d!", MAX_MATERIALS);

    if (IsValidDynamicObject(ObjData[slot][oObject]))
      DestroyDynamicObject(ObjData[slot][oObject]), ObjData[slot][oObject] = INVALID_STREAMER_ID;

    ObjData[slot][oMaterials][index] = GetTextureIndex(model, txdname, texture);
    ObjData[slot][oMatsColor][index] = RGBAToInt(color[0], color[1], color[2], color[3]);
    Object_Refresh(slot);
    Object_Save(slot);
    Streamer_Update(playerid);
  } else if (!strcmp(opt, "resetmaterial")) {
    new id, index;
    if (sscanf(value, "dd", id, index))
      return SendSyntaxMessage(playerid, "/editobject resetmaterial [object id] [index]");

    if (!Iter_Contains(Obj, id))
      return SendErrorMessage(playerid, "Invalid object id!");

    ObjData[id][oMatsColor][index] = 0;
    ObjData[id][oMaterials][index] = 0;
    RemoveDynamicObjectMaterial(ObjData[id][oObject], index);

    Object_Save(id);
    Streamer_Update(playerid);
    SendCustomMessage(playerid, "OBJECT", "You've reset object material of object id: "YELLOW"%d", id);
  } else if (!strcmp(opt, "textprop")) {
    new id, index;
    if (sscanf(value, "dd", id, index))
      return SendSyntaxMessage(playerid, "/editobject textprop [object id] [index]");

    if (!Iter_Contains(Obj, id))
      return SendErrorMessage(playerid, "Invalid object id!");

    if((index >= 9) || (index < 0))
      return SendErrorMessage(playerid,"index cannot go below 0 or over 9!");

    if (ObjData[id][oMatsText]) {
      new ind,text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
      GetDynamicObjectMaterialText(ObjData[id][oObject],ind,text,size,font,fsize,bold,fcolor,bcolor,alignment);
      ObjData[id][oMatsTextIndex] = index;
      FixText(text);
      format(ObjData[id][oText], 256, "%s", text);
      ObjData[id][oMatsTextSize] = size;
      format(ObjData[id][oMatsTextFont], 32, "%s", font);
      ObjData[id][oMatsTextFontSize] = fsize;
      ObjData[id][oMatsTextBold] = bold;
      ObjData[id][oMatsTextColor] = fcolor;
      ObjData[id][oMatsTextBackColor] = bcolor;
      ObjData[id][oMatsTextAlignment] = alignment;
      Streamer_Update(playerid);
      SetDynamicObjectMaterialText(ObjData[id][oObject],ObjData[id][oMatsTextIndex],ObjData[id][oText],ObjData[id][oMatsTextSize],ObjData[id][oMatsTextFont],ObjData[id][oMatsTextFontSize],ObjData[id][oMatsTextBold],ObjData[id][oMatsTextColor],ObjData[id][oMatsTextBackColor],ObjData[id][oMatsTextAlignment]);
      SetPVarInt(playerid, "EditObjMatsTextID", id);
      SetPVarInt(playerid, "EditObjMatsTextIndex", index);
      Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
    } else {
      ObjData[id][oMatsText] = 1;
      ObjData[id][oMatsTextIndex] = index;
      new text[256];
      format(text,sizeof(text),"Text Here");
      FixText(text);
      format(ObjData[id][oText], 256, text);
      ObjData[id][oMatsTextSize] = OBJECT_MATERIAL_SIZE_256x128;
      format(ObjData[id][oMatsTextFont], 32, "Arial");
      ObjData[id][oMatsTextFontSize] = 24;
      ObjData[id][oMatsTextBold] = 1;
      ObjData[id][oMatsTextColor] = 0xFFFFFFFF;
      ObjData[id][oMatsTextBackColor] = 0xFF000000;
      ObjData[id][oMatsTextAlignment] = 0;
      SetDynamicObjectMaterialText(ObjData[id][oObject],ObjData[id][oMatsTextIndex],ObjData[id][oText],ObjData[id][oMatsTextSize],ObjData[id][oMatsTextFont],ObjData[id][oMatsTextFontSize],ObjData[id][oMatsTextBold],ObjData[id][oMatsTextColor],ObjData[id][oMatsTextBackColor],ObjData[id][oMatsTextAlignment]);
      Streamer_Update(playerid);
      SetPVarInt(playerid, "EditObjMatsTextID", id);
      SetPVarInt(playerid, "EditObjMatsTextIndex", index);
      Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
      Object_Save(id);
    }
  } else if (!strcmp(opt, "resettextprop")) {
    new id;
    if (sscanf(value, "d", id))
      return SendSyntaxMessage(playerid, "/editobject resettextprop [object id]");

    if (!Iter_Contains(Obj, id))
      return SendErrorMessage(playerid, "Invalid object id!");

    RemoveDynamicObjectMaterialText(ObjData[id][oObject], ObjData[id][oMatsTextIndex]);
    ObjData[id][oMatsText] = 0;
    ObjData[id][oMatsTextIndex] = 0;
    format(ObjData[id][oText], 256, "Text Here");
    ObjData[id][oMatsTextSize] = OBJECT_MATERIAL_SIZE_256x128;
    format(ObjData[id][oMatsTextFont], 32, "Arial");
    ObjData[id][oMatsTextFontSize] = 24;
    ObjData[id][oMatsTextBold] = 1;
    ObjData[id][oMatsTextColor] = 0xFFFFFFFF;
    ObjData[id][oMatsTextBackColor] = 0xFF000000;
    ObjData[id][oMatsTextAlignment] = 0;
    Object_Refresh(id);
    Object_Save(id);
    Streamer_Update(playerid);
    SendCustomMessage(playerid, "OBJECT", "You've reset text prop of object id: "YELLOW"%d",id);
  } else if (!strcmp(opt, "vw")) {
    new id, vw;
    if (sscanf(value, "dd", id, vw))
      return SendSyntaxMessage(playerid, "/editobject vw [object id] [virtual world]");

    if (!Iter_Contains(Obj, id))
      return SendErrorMessage(playerid, "Invalid object id!");

    ObjData[id][oVw] = vw;
    Object_Refresh(id);
    Object_Save(id);
    SendCustomMessage(playerid, "OBJECT", "You've change virtual world of object id: "YELLOW"%d "WHITE"to "YELLOW"%d",id,vw);
  } else if (!strcmp(opt, "int")) {
    new id, int;
    if (sscanf(value, "dd", id, int))
      return SendSyntaxMessage(playerid, "/editobject int [object id] [interior id]");

    if (!Iter_Contains(Obj, id))
      return SendErrorMessage(playerid, "Invalid object id!");

    ObjData[id][oInt] = int;
    Object_Refresh(id);
    Object_Save(id);
    SendCustomMessage(playerid, "OBJECT", "You've change interior id of object id: "YELLOW"%d "WHITE"to "YELLOW"%d",id,int);
  } else if (!strcmp(opt, "drawdistance")) {
    new id, Float:stream;
    if (sscanf(value, "df", id, stream))
      return SendSyntaxMessage(playerid, "/editobject drawdistance [object id] [draw distance]");

    if (!Iter_Contains(Obj, id))
      return SendErrorMessage(playerid, "Invalid object id!");

    ObjData[id][oStream] = stream;
    Object_Refresh(id);
    Object_Save(id);
    SendCustomMessage(playerid, "OBJECT", "You've change draw distance of object id: "YELLOW"%d "WHITE"to "YELLOW"%.1f",id,stream);
  }
  return 1;
}

CMD:destroyobject(playerid, params[]) {
  if (CheckAdmin(playerid, 5)) 
    return PermissionError(playerid);

  new id;
  if (sscanf(params, "d", id))
    return SendSyntaxMessage(playerid, "/destroyobject [object id]");

  if (!Iter_Contains(Obj, id)) return SendErrorMessage(playerid, "Invalid object id!");

  Object_Delete(id);
  SendCustomMessage(playerid, "OBJECT", "You've deleted object id: "YELLOW"%d", id);
  Streamer_Update(playerid);
  return 1;
}

CMD:objectinfo(playerid, params[]) {
  if (CheckAdmin(playerid, 5))
    return PermissionError(playerid);

  new id, str[1024];
  if (sscanf(params, "d", id))
    return SendSyntaxMessage(playerid, "/objectinfo [object id]");

  if (!Iter_Contains(Obj, id))
    return SendErrorMessage(playerid, "Invalid object id!");

  strcat(str,sprintf("Model:\t%d\n",ObjData[id][oModel]));
  strcat(str,sprintf("Position X:\t%.2f\n",ObjData[id][oPos][0]));
  strcat(str,sprintf("Position Y:\t%.2f\n",ObjData[id][oPos][1]));
  strcat(str,sprintf("Position Z:\t%.2f\n",ObjData[id][oPos][2]));
  strcat(str,sprintf("Position RotX:\t%.2f\n",ObjData[id][oRot][0]));
  strcat(str,sprintf("Position RotY:\t%.2f\n",ObjData[id][oRot][1]));
  strcat(str,sprintf("Position RotZ:\t%.2f\n",ObjData[id][oRot][2]));
  strcat(str,sprintf("Virtual World:\t%d\n",ObjData[id][oVw]));
  strcat(str,sprintf("Interior ID:\t%d\n",ObjData[id][oInt]));
  strcat(str,sprintf("Draw Distance:\t%.1f",ObjData[id][oStream]));
  for (new j = 0; j < MAX_MATERIALS; j ++) if (ObjData[id][oMaterials][j] > 0) {
    strcat(str,sprintf("\nMaterial Index:\t%d\n",j));
    strcat(str,sprintf("Material Model:\t%d\n",GetTModel(ObjData[id][oMaterials][j])));
    strcat(str,sprintf("Material TxdName:\t%s\n",GetTXDName(ObjData[id][oMaterials][j])));
    strcat(str,sprintf("Material Texture:\t%s",GetTextureName(ObjData[id][oMaterials][j])));
  }
  if (ObjData[id][oMatsText]) {
    strcat(str,sprintf("\nMaterial Text Index:\t%d\n",ObjData[id][oMatsTextIndex]));
    strcat(str,sprintf("Material Text (text):\t%s\n",ObjData[id][oText]));
    strcat(str,sprintf("Material Text Resolution:\t%s\n",TextResolution[(ObjData[id][oMatsTextSize]/10)-1]));
    strcat(str,sprintf("Material Text Font:\t%s\n",ObjData[id][oMatsTextFont]));
    strcat(str,sprintf("Material Text Font Size:\t%d\n",ObjData[id][oMatsTextFontSize]));
    strcat(str,sprintf("Material Text Bold:\t%s\n",(ObjData[id][oMatsTextBold]) ? (GREEN"YES") : (RED"NO")));
    strcat(str,sprintf("Material Text Color:\t%d\n",ObjData[id][oMatsTextColor]));
    strcat(str,sprintf("Material Text Background:\t%d\n",ObjData[id][oMatsTextBackColor]));
    strcat(str,sprintf("Material Text Alignment:\t%s",(ObjData[id][oMatsTextAlignment] == 0) ? ("Left") : ((ObjData[id][oMatsTextAlignment] == 1) ? ("Center") : ((ObjData[id][oMatsTextAlignment] == 2) ? ("Right") : ("")))));
  }
  Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_TABLIST, sprintf("Object ID: %d", id), str, "OK", "");
  return 1;
}

Dialog:Object_TextMenu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				Dialog_Show(playerid,Object_TextSetMessage,DIALOG_STYLE_INPUT,"Material Text: Set Text","Input text: (max length = 255 characters)","Set","Back");
				return 1;
			}
			case 1:
			{
				Dialog_Show(playerid,Object_TextSetResolution,DIALOG_STYLE_LIST,"Material Text: Set Resolution","32x32\n64x32\n64x64\n128x32\n128x64\n128x128\n256x32\n256x64\n256x128\n256x256\n512x64\n512x128\n512x256\n512x512","Set","Back");
				return 1;
			}
			case 2:
			{
        new fonts[256];
        Loop(i,sizeof(WinFonts)) {
          strcat(fonts,WinFonts[i],sizeof(fonts));
          strcat(fonts,"\n",sizeof(fonts));
				}
        strcat(fonts,"Custom",sizeof(fonts));
        Dialog_Show(playerid,Object_TextSetFont,DIALOG_STYLE_LIST,"Material Text: Set Font",fonts,"Set","Back"); return 1;
			}
			case 3:
			{
				Dialog_Show(playerid,Object_TextSetFontSize,DIALOG_STYLE_INPUT,"Material Text: Set Font Size","Input font size: (1-255)","Set","Back");
				return 1;
			}
			case 4:
			{
				new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
				new id = GetPVarInt(playerid,"EditObjMatsTextID"),
            index = GetPVarInt(playerid,"EditObjMatsTextIndex");
                GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
                ObjData[id][oMatsTextBold] = ((bold == 1) ? 0 : 1);
                Object_Refresh(id);
                Object_Save(id);
                Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
                return 1;
			}
			case 5:
			{
				Dialog_Show(playerid,Object_TextSetFontColor,DIALOG_STYLE_INPUT,"Material Text: Set Font Color","Input color in RGBA format: (ex 255 0 0 255 = yellow)","Set","Back");
				return 1;
			}
			case 6:
			{
				Dialog_Show(playerid,Object_TextSetColor,DIALOG_STYLE_INPUT,"Material Text: Set Background Color","Input color in RGBA format: (ex 255 0 0 255 = yellow)","Set","Back");
				return 1;
			}
			case 7:
			{
				Dialog_Show(playerid,Object_TextSetAlignment,DIALOG_STYLE_LIST,"Material Text: Set Alignment","Left\nCenter\nRight","Set","Back");
				return 1;
			}
		}
	}
	DeletePVar(playerid,"EditObjMatsTextID");
	DeletePVar(playerid,"EditObjMatsTextIndex");
	return 1;
}
Dialog:Object_TextSetMessage(playerid, response, listitem, inputtext[])
{
	if(response) {
		new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
		new id = GetPVarInt(playerid,"EditObjMatsTextID"),
        index = GetPVarInt(playerid,"EditObjMatsTextIndex");

        GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
        FixText(inputtext);
        format(ObjData[id][oText], 256, "%s", (isnull(inputtext)) ? (text) : (inputtext));
        Object_Refresh(id);
        Object_Save(id);
	}
	Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
	return 1;
}
Dialog:Object_TextSetResolution(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
		new id = GetPVarInt(playerid,"EditObjMatsTextID"),
	    	index = GetPVarInt(playerid,"EditObjMatsTextIndex");
    
        GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
        ObjData[id][oMatsTextSize] = ((listitem+1)*10);
        Object_Refresh(id);
        Object_Save(id);
	}
	Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
	return 1;
}
Dialog:Object_TextSetFont(playerid, response, listitem, inputtext[])
{
	if (!response)
    return Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
  
    if (listitem < sizeof(WinFonts)) {

    new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
    new id = GetPVarInt(playerid,"EditObjMatsTextID"),
        index = GetPVarInt(playerid,"EditObjMatsTextIndex");
    GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
    format(ObjData[id][oMatsTextFont], 32, WinFonts[listitem]);
    Object_Refresh(id);
    Object_Save(id);
    } else {
      Dialog_Show(playerid,Object_TextSetCustomFont,DIALOG_STYLE_INPUT,"Material Text: Set Custom Font","Input font name:","Input","Back");
    } return 1;
}
Dialog:Object_TextSetCustomFont(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
		new id = GetPVarInt(playerid,"EditObjMatsTextID"),
	    	index = GetPVarInt(playerid,"EditObjMatsTextIndex");
    
        GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
        format(ObjData[id][oMatsTextFont], 32, "%s", (isnull(inputtext)) ? (text) : (inputtext));
        Object_Refresh(id);
        Object_Save(id);
	}
	Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
	return 1;
}
Dialog:Object_TextSetFontSize(playerid, response, listitem, inputtext[])
{
	if(response)
	{
      new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
      new id = GetPVarInt(playerid,"EditObjMatsTextID"),
        index = GetPVarInt(playerid,"EditObjMatsTextIndex");
      GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
      ObjData[id][oMatsTextFontSize] = (isnull(inputtext)) ? fsize : strval(inputtext);
      Object_Refresh(id);
      Object_Save(id);
	}
	Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
	return 1;
}
Dialog:Object_TextSetFontColor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new alpha,red,green,blue;
		if(!sscanf(inputtext,"dddD(255)",red,green,blue,alpha))
		{
			new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
			new id = GetPVarInt(playerid,"EditObjMatsTextID"),
	        index = GetPVarInt(playerid,"EditObjMatsTextIndex");
            GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
            ObjData[id][oMatsTextColor] = RGBAToInt(alpha,red,green,blue);
            Object_Refresh(id);
            Object_Save(id);
		}
	}
	Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
	return 1;
}
Dialog:Object_TextSetColor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new alpha,red,green,blue;
		if(!sscanf(inputtext,"dddD(255)",red,green,blue,alpha))
		{
			new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
			new id = GetPVarInt(playerid,"EditObjMatsTextID"),
	    	  index = GetPVarInt(playerid,"EditObjMatsTextIndex");
            GetDynamicObjectMaterialText(ObjData[id][oObject],index,text,size,font,fsize,bold,fcolor,bcolor,alignment);
            ObjData[id][oMatsTextBackColor] = RGBAToInt(alpha,red,green,blue);
            Object_Refresh(id);
            Object_Save(id);
		}
	}
	Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
	return 1;
}
Dialog:Object_TextSetAlignment(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new text[256],size,font[32],fsize,bold,fcolor,bcolor,alignment;
		new id = GetPVarInt(playerid,"EditObjMatsTextID"),
        index = GetPVarInt(playerid,"EditObjMatsTextIndex");
    
        GetDynamicObjectMaterialText(ObjData[id][oObject], index, text, size, font, fsize, bold, fcolor, bcolor, alignment);
    
        ObjData[id][oMatsTextAlignment] = listitem;
        Object_Refresh(id);
        Object_Save(id);
	}
	Dialog_Show(playerid,Object_TextMenu,DIALOG_STYLE_LIST,"Material Text","Text\nResolution\nFont\nFont Size\nToggle Bold\nFont Color\nBackground Color\nText Alignment","Select","Close");
	return 1;
}
