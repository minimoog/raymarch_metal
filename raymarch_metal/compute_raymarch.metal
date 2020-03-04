//
//  compute_raymarch.metal
//  raymarch_metal
//
//  Created by Antonie Jovanoski on 3/4/20.
//  Copyright © 2020 Antonie Jovanoski. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//primitives

float sdSphere(float3 pos, float radius)
{
    return length(pos) - radius;
}

float udBox(float3 pos, float3 extents)
{
    return length(max(abs(pos) - extents, 0.0));
}

float udRoundBox(float3 pos, float3 extents, float r)
{
    return length(max(abs(pos) - extents, 0.0)) - r;
}

float sdBox(float3 pos, float3 extents)
{
    float3 d = abs(pos) - extents;
    
    return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

float sdTorus(float3 pos, float2 t)
{
    float2 q = float2(length(pos) - t.x, pos.y);
    
    return length(q) - t.y;
}

float cylinder(float3 pos, float3 c)
{
    return length(pos.xz - c.xy) - c.z;
}

float sdCone(float3 pos, float2 c)
{
    float q = length(pos.xy);
    
    return dot(c, float2(q, pos.z));
}

float sdPlane(float3 pos, float4 n)
{
    return dot(pos, n.xyz) + n.w;
}

float sdHexPrism(float3 pos, float2 h)
{
    float3 q = abs(pos);
    
    return max(q.z - h.y, max(q.x + q.y * 0.57735, q.y * 1.1547) - h.x);
}

float sdTriPrism(float3 pos, float2 h)
{
    float3 q = abs(pos);
    return max(q.z - h.y, max(q.x * 0.866025 + pos.y * 0.5, -pos.y) - h.x * 0.5);
}

// domain operations

float opUnion(float d1, float d2)
{
    return min(d1, d2);
}

float opSubtract(float d1, float d2)
{
    return max(-d1, d2);
}

float opIntersect(float d1, float d2)
{
    return max(d1, d2);
}

//uniform mat4 u_mtx;
//uniform vec4 u_lightDirTime;

#define u_lightDir u_lightDirTime.xyz
#define u_time     u_lightDirTime.w

float sceneDist(float3 pos)
{
    float d1 = udRoundBox(pos, float3(2.5, 2.5, 2.5), 0.5);
    float d2 = sdSphere(pos + float3( 4.0, 0.0, 0.0), 1.0);
    float d3 = sdSphere(pos + float3(-4.0, 0.0, 0.0), 1.0);
    float d4 = sdSphere(pos + float3( 0.0, 4.0, 0.0), 1.0);
    float d5 = sdSphere(pos + float3( 0.0,-4.0, 0.0), 1.0);
    float d6 = sdSphere(pos + float3( 0.0, 0.0, 4.0), 1.0);
    float d7 = sdSphere(pos + float3( 0.0, 0.0,-4.0), 1.0);
    float dist = min(min(min(min(min(min(d1, d2), d3), d4), d5), d6), d7);
    return dist;
}

kernel void shader(texture2d<float, access::write> output [[texture(0)]],
                   constant Uniforms& uniforms [[buffer(0)]],
                   uint2 gid [[thread_position_in_grid]])
{
    
}
