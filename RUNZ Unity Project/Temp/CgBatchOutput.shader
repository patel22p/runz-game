// Upgrade NOTE: replaced 'glstate.matrix.mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'glstate.matrix.texture[0]' with 'UNITY_MATRIX_TEXTURE0'
// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'
// Upgrade NOTE: replaced 'texRECT' with 'tex2D'

Shader "Hidden/Glow Downsample" {

Properties {
	_Color ("Color", color) = (1,1,1,0)
	_MainTex ("", RECT) = "white" {}
}

#LINE 44



Category {
	ZTest Always Cull Off ZWrite Off Fog { Mode Off }
	
	// -----------------------------------------------------------
	// ARB fragment program
	
	Subshader { 
		Pass {
		
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 23 to 23
//   d3d9 - ALU: 27 to 27
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 9 [_MainTex_TexelSize]
"!!ARBvp1.0
# 23 ALU
PARAM c[10] = { { 0, 1 },
		state.matrix.mvp,
		state.matrix.texture[0],
		program.local[9] };
TEMP R0;
TEMP R1;
MOV R1.zw, c[0].x;
MOV R0.zw, c[0].x;
MOV R0.xy, vertex.texcoord[0];
DP4 R1.y, R0, c[6];
DP4 R1.x, R0, c[5];
MOV R0.xy, -c[9];
MOV R0.zw, c[0].xyxy;
ADD result.texcoord[0], R1, R0;
MOV R0.zw, c[0].xyxy;
MOV R0.x, c[9];
MOV R0.y, -c[9];
ADD result.texcoord[1], R1, R0;
MOV R0.xy, c[9];
MOV R0.zw, c[0].xyxy;
ADD result.texcoord[2], R1, R0;
MOV R0.zw, c[0].xyxy;
MOV R0.x, -c[9];
MOV R0.y, c[9];
ADD result.texcoord[3], R1, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 23 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Vector 8 [_MainTex_TexelSize]
"vs_2_0
; 27 ALU
def c9, 0.00000000, 2.00000000, 1.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r1.zw, c9.x
mov r0.zw, c9.x
mov r0.xy, v1
dp4 r1.y, r0, c5
dp4 r0.y, r0, c4
mov r1.x, c8.y
mad r1.y, c9, r1.x, r1
mov r0.x, c8
mad r1.x, c9.y, r0, r0.y
mov r0.xy, -c8
mov r0.zw, c9.xyxz
add oT0, r1, r0
mov r0.zw, c9.xyxz
mov r0.x, c8
mov r0.y, -c8
add oT1, r1, r0
mov r0.xy, c8
mov r0.zw, c9.xyxz
add oT2, r1, r0
mov r0.zw, c9.xyxz
mov r0.x, -c8
mov r0.y, c8
add oT3, r1, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix0 glstate_matrix_texture0
uniform mat4 glstate_matrix_texture0;

varying highp vec4 xlv_TEXCOORD0_3;
varying highp vec4 xlv_TEXCOORD0_2;
varying highp vec4 xlv_TEXCOORD0_1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _MainTex_TexelSize;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec4 uv;
  vec4 tmpvar_2[4];
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.x = tmpvar_1.x;
  tmpvar_3.y = tmpvar_1.y;
  uv.xy = (gl_TextureMatrix0 * tmpvar_3).xy;
  uv.zw = vec2(0.0, 0.0);
  highp float tmpvar_4;
  tmpvar_4 = _MainTex_TexelSize.x;
  highp float tmpvar_5;
  tmpvar_5 = _MainTex_TexelSize.y;
  highp vec4 tmpvar_6;
  tmpvar_6.zw = vec2(0.0, 1.0);
  tmpvar_6.x = -(tmpvar_4);
  tmpvar_6.y = -(tmpvar_5);
  tmpvar_2[0] = (uv + tmpvar_6);
  highp vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 1.0);
  tmpvar_7.x = tmpvar_4;
  tmpvar_7.y = -(tmpvar_5);
  tmpvar_2[1] = (uv + tmpvar_7);
  highp vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 1.0);
  tmpvar_8.x = tmpvar_4;
  tmpvar_8.y = tmpvar_5;
  tmpvar_2[2] = (uv + tmpvar_8);
  highp vec4 tmpvar_9;
  tmpvar_9.zw = vec2(0.0, 1.0);
  tmpvar_9.x = -(tmpvar_4);
  tmpvar_9.y = tmpvar_5;
  tmpvar_2[3] = (uv + tmpvar_9);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2[0];
  xlv_TEXCOORD0_1 = tmpvar_2[1];
  xlv_TEXCOORD0_2 = tmpvar_2[2];
  xlv_TEXCOORD0_3 = tmpvar_2[3];
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD0_3;
varying highp vec4 xlv_TEXCOORD0_2;
varying highp vec4 xlv_TEXCOORD0_1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform highp vec4 _Color;
void main ()
{
  vec4 tmpvar_1[4];
  tmpvar_1[0] = xlv_TEXCOORD0;
  tmpvar_1[1] = xlv_TEXCOORD0_1;
  tmpvar_1[2] = xlv_TEXCOORD0_2;
  tmpvar_1[3] = xlv_TEXCOORD0_3;
  mediump vec4 c;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, tmpvar_1[0].xy);
  c = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_1[1].xy);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_1[2].xy);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_1[3].xy);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((((c + tmpvar_3) + tmpvar_4) + tmpvar_5) / 4.0);
  c = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz * _Color.xyz);
  c.xyz = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (c.xyz * (c.w + _Color.w));
  c.xyz = tmpvar_8;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 12 to 12, TEX: 4 to 4
//   d3d9 - ALU: 9 to 9, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 12 ALU, 4 TEX
PARAM c[2] = { program.local[0],
		{ 0.25, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3, fragment.texcoord[3], texture[0], 2D;
TEX R2, fragment.texcoord[2], texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD R0, R0, R1;
ADD R0, R0, R2;
ADD R0, R0, R3;
MUL R0, R0, c[1].x;
ADD R0.w, R0, c[0];
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, c[1].y;
END
# 12 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 9 ALU, 4 TEX
dcl_2d s0
def c1, 0.25000000, 0.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
texld r0, t3, s0
texld r1, t2, s0
texld r2, t1, s0
texld r3, t0, s0
add_pp r2, r3, r2
add_pp r1, r2, r1
add_pp r0, r1, r0
mul_pp r0, r0, c1.x
add r1.x, r0.w, c0.w
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r1.x
mov_pp r0.w, c1.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 77


		}
	}
			
	// -----------------------------------------------------------
	// Radeon 9000
	
	Subshader {
		Pass {


Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 23 to 23
//   d3d9 - ALU: 27 to 27
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 9 [_MainTex_TexelSize]
"!!ARBvp1.0
# 23 ALU
PARAM c[10] = { { 0, 1 },
		state.matrix.mvp,
		state.matrix.texture[0],
		program.local[9] };
TEMP R0;
TEMP R1;
MOV R1.zw, c[0].x;
MOV R0.zw, c[0].x;
MOV R0.xy, vertex.texcoord[0];
DP4 R1.y, R0, c[6];
DP4 R1.x, R0, c[5];
MOV R0.xy, -c[9];
MOV R0.zw, c[0].xyxy;
ADD result.texcoord[0], R1, R0;
MOV R0.zw, c[0].xyxy;
MOV R0.x, c[9];
MOV R0.y, -c[9];
ADD result.texcoord[1], R1, R0;
MOV R0.xy, c[9];
MOV R0.zw, c[0].xyxy;
ADD result.texcoord[2], R1, R0;
MOV R0.zw, c[0].xyxy;
MOV R0.x, -c[9];
MOV R0.y, c[9];
ADD result.texcoord[3], R1, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 23 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Vector 8 [_MainTex_TexelSize]
"vs_2_0
; 27 ALU
def c9, 0.00000000, 2.00000000, 1.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r1.zw, c9.x
mov r0.zw, c9.x
mov r0.xy, v1
dp4 r1.y, r0, c5
dp4 r0.y, r0, c4
mov r1.x, c8.y
mad r1.y, c9, r1.x, r1
mov r0.x, c8
mad r1.x, c9.y, r0, r0.y
mov r0.xy, -c8
mov r0.zw, c9.xyxz
add oT0, r1, r0
mov r0.zw, c9.xyxz
mov r0.x, c8
mov r0.y, -c8
add oT1, r1, r0
mov r0.xy, c8
mov r0.zw, c9.xyxz
add oT2, r1, r0
mov r0.zw, c9.xyxz
mov r0.x, -c8
mov r0.y, c8
add oT3, r1, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

}

#LINE 94


			
			// average 2x2 samples
			SetTexture [_MainTex] {constantColor (0,0,0,0.25) combine texture * constant alpha}
			SetTexture [_MainTex] {constantColor (0,0,0,0.25) combine texture * constant + previous}
			SetTexture [_MainTex] {constantColor (0,0,0,0.25) combine texture * constant + previous}
			SetTexture [_MainTex] {constantColor (0,0,0,0.25) combine texture * constant + previous}
			// apply glow tint and add additional glow
			SetTexture [_MainTex] {constantColor[_Color] combine previous * constant, previous + constant}
			SetTexture [_MainTex] {constantColor (0,0,0,0) combine previous * previous alpha, constant}
		}
	}
}

Fallback off

}
