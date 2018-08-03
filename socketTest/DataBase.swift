//
//  DataBase.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/8/3.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation

var totalArr:[UInt8] = [72, 84, 84, 80, 47, 49, 46, 49, 32, 50, 48, 48, 32, 79, 75, 13, 10, 13, 10, 32, 32, 32, 32, 32, 163, 187, 32, 32, 32, 32, 32, 32, 27, 91, 51, 51, 59, 49, 109, 80, 84, 84, 27, 91, 109, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 161, 80, 32, 32, 32, 162, 169, 32, 32, 32, 32, 32, 32, 32, 32, 161, 80, 32, 32, 163, 187, 32, 32, 32, 32, 32, 32, 27, 91, 49, 109, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 171, 27, 91, 109, 13, 10, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 49, 109, 49, 52, 48, 46, 49, 49, 50, 46, 49, 55, 50, 46, 49, 49, 32, 27, 91, 109, 161, 80, 32, 32, 32, 32, 32, 162, 168, 27, 91, 52, 55, 109, 162, 105, 27, 91, 49, 109, 162, 170, 27, 91, 52, 48, 109, 162, 105, 162, 171, 27, 91, 109, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 49, 109, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 109, 13, 10, 32, 32, 162, 122, 162, 119, 162, 123, 32, 32, 32, 32, 32, 27, 91, 51, 51, 59, 49, 109, 167, 229, 189, 240, 189, 240, 185, 234, 183, 126, 167, 123, 27, 91, 109, 32, 32, 32, 32, 32, 32, 32, 32, 162, 168, 27, 91, 51, 48, 59, 52, 55, 109, 162, 100, 27, 91, 51, 55, 109, 162, 105, 162, 105, 27, 91, 49, 109, 162, 170, 162, 105, 27, 91, 52, 48, 109, 162, 171, 27, 91, 109, 32, 32, 32, 161, 80, 32, 32, 32, 27, 91, 49, 109, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 171, 32, 32, 27, 91, 109, 161, 80, 27, 91, 109, 13, 10, 32, 32, 162, 120, 27, 91, 49, 109, 161, 86, 27, 91, 109, 162, 124, 162, 123, 32, 32, 32, 27, 91, 49, 109, 112, 116, 116, 46, 99, 99, 32, 32, 32, 32, 32, 32, 32, 27, 91, 109, 32, 32, 32, 32, 32, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 49, 109, 162, 170, 27, 91, 52, 48, 109, 162, 105, 162, 171, 27, 91, 109, 32, 32, 32, 32, 27, 91, 49, 109, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 109, 13, 10, 32, 32, 162, 120, 27, 91, 49, 109, 161, 86, 27, 91, 109, 32, 32, 162, 120, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 171, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 27, 91, 49, 109, 162, 170, 27, 91, 52, 48, 109, 162, 171, 27, 91, 109, 32, 32, 27, 91, 49, 109, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 171, 32, 32, 27, 91, 109, 163, 187, 32, 32, 161, 80, 27, 91, 109, 13, 10, 162, 119, 162, 125, 32, 32, 32, 32, 162, 120, 162, 122, 162, 119, 162, 119, 162, 123, 32, 32, 161, 80, 32, 32, 32, 32, 32, 32, 32, 162, 170, 162, 171, 32, 32, 32, 32, 32, 32, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 169, 27, 91, 49, 109, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 32, 32, 32, 32, 27, 91, 109, 161, 80, 27, 91, 109, 13, 10, 32, 32, 32, 32, 32, 32, 32, 32, 162, 124, 162, 116, 32, 32, 27, 91, 51, 51, 59, 49, 109, 161, 86, 27, 91, 109, 162, 120, 32, 32, 32, 32, 32, 32, 161, 80, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 49, 109, 162, 168, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 171, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 109, 161, 80, 27, 91, 109, 13, 10, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 162, 120, 162, 122, 162, 119, 162, 119, 162, 119, 162, 123, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 104, 162, 104, 162, 103, 162, 103, 162, 102, 162, 102, 162, 101, 162, 101, 162, 100, 162, 99, 162, 98, 27, 91, 109, 13, 10, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 162, 122, 162, 119, 162, 114, 162, 125, 27, 91, 49, 109, 161, 86, 27, 91, 51, 51, 109, 161, 86, 27, 91, 109, 32, 32, 162, 124, 32, 162, 168, 27, 91, 52, 55, 109, 162, 105, 162, 105, 162, 105, 162, 105, 162, 105, 27, 91, 52, 48, 109, 162, 104, 162, 104, 162, 103, 162, 103, 162, 102, 162, 102, 162, 101, 162, 101, 162, 100, 162, 100, 162, 99, 162, 99, 162, 98, 27, 91, 109, 13, 10, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 162, 120, 27, 91, 49, 109, 161, 86, 161, 86, 27, 91, 109, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 162, 170, 27, 91, 52, 55, 109, 162, 105, 162, 105, 27, 91, 52, 48, 109, 32, 32, 32, 32, 32, 32, 162, 105, 162, 104, 162, 104, 162, 103, 162, 103, 162, 102, 162, 102, 162, 101, 162, 101, 162, 100, 162, 99, 162, 98, 27, 91, 109, 13, 10, 0, 255, 253, 24, 255, 250, 24, 1, 255, 240, 255, 253, 31, 255, 251, 1, 255, 251, 3, 255, 251, 0, 255, 253, 0, 27, 91, 72, 27, 91, 50, 74, 27, 91, 51, 54, 59, 52, 49, 109, 162, 171, 27, 91, 51, 48, 109, 162, 172, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 49, 59, 51, 49, 109, 61, 163, 184, 27, 91, 59, 51, 48, 59, 52, 49, 109, 161, 196, 164, 71, 61, 45, 44, 32, 32, 32, 32, 27, 91, 51, 49, 109, 162, 27, 91, 52, 54, 109, 103, 162, 101, 162, 27, 91, 51, 54, 109, 99, 27, 91, 49, 59, 51, 51, 109, 32, 32, 162, 126, 32, 192, 176, 167, 218, 192, 191, 168, 190, 197, 206, 166, 110, 182, 220, 161, 72, 32, 27, 91, 59, 51, 48, 59, 52, 54, 109, 161, 27, 91, 52, 48, 109, 185, 27, 91, 51, 51, 109, 47, 27, 91, 51, 48, 109, 162, 27, 91, 51, 55, 109, 99, 162, 101, 162, 103, 162, 168, 27, 91, 52, 55, 109, 162, 27, 91, 51, 48, 109, 171, 32, 161, 27, 91, 51, 55, 59, 52, 51, 109, 191, 27, 91, 52, 48, 109, 92, 32, 32, 32, 27, 91, 109, 13, 10, 27, 91, 51, 55, 59, 52, 49, 109, 92, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 48, 109, 162, 119, 163, 184, 161, 100, 161, 202, 161, 199, 27, 91, 51, 55, 109, 162, 98, 32, 32, 32, 32, 27, 91, 51, 48, 109, 161, 169, 27, 91, 59, 51, 51, 59, 52, 49, 109, 162, 99, 32, 32, 32, 32, 27, 91, 51, 48, 109, 162, 64, 27, 91, 51, 49, 109, 162, 27, 91, 52, 54, 109, 101, 162, 27, 91, 51, 54, 109, 98, 27, 91, 49, 59, 51, 51, 109, 32, 32, 32, 32, 162, 65, 32, 32, 32, 32, 32, 32, 162, 65, 32, 32, 32, 32, 32, 27, 91, 59, 51, 48, 59, 52, 54, 109, 161, 27, 91, 52, 51, 109, 191, 27, 91, 51, 51, 59, 52, 55, 109, 162, 27, 91, 51, 48, 109, 171, 32, 32, 27, 91, 51, 55, 109, 161, 27, 91, 51, 48, 109, 99, 32, 32, 161, 27, 91, 51, 55, 109, 99, 32, 32, 27, 91, 51, 51, 109, 161, 169, 27, 91, 51, 48, 109, 161, 27, 91, 51, 51, 109, 191, 27, 91, 52, 48, 109, 92, 32, 27, 91, 109, 13, 10, 27, 91, 49, 59, 51, 48, 59, 52, 49, 109, 162, 66, 32, 27, 91, 59, 51, 48, 59, 52, 49, 109, 161, 197, 27, 91, 51, 55, 109, 161, 197, 162, 98, 162, 99, 162, 100, 162, 101, 162, 103, 27, 91, 51, 48, 59, 52, 55, 109, 162, 99, 162, 101, 162, 100, 27, 91, 51, 55, 59, 52, 49, 109, 162, 103, 162, 27, 91, 52, 51, 109, 100, 27, 91, 51, 48, 109, 70, 61, 44, 27, 91, 51, 51, 59, 52, 49, 109, 162, 27, 91, 51, 49, 109, 102, 32, 32, 32, 162, 27, 91, 51, 48, 109, 66, 27, 91, 51, 49, 109, 162, 27, 91, 52, 54, 109, 102, 162, 27, 91, 51, 54, 109, 98, 27, 91, 49, 59, 51, 54, 109, 161, 197, 161, 197, 161, 197, 161, 197, 161, 197, 161, 197, 161, 197, 161, 197, 95, 27, 91, 59, 51, 48, 59, 52, 54, 109, 55, 27, 91, 52, 51, 109, 78, 27, 91, 51, 55, 59, 52, 55, 109, 161, 27, 91, 51, 48, 109, 107, 162, 100, 162, 99, 27, 91, 51, 51, 109, 40, 27, 91, 51, 48, 109, 162, 100, 162, 99, 162, 100, 161, 27, 91, 51, 55, 109, 107, 27, 91, 51, 48, 109, 86, 27, 91, 52, 48, 109, 161, 27, 91, 52, 51, 109, 191, 27, 91, 109, 13, 10, 27, 91, 51, 49, 59, 52, 55, 109, 162, 111, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 55, 109, 47, 27, 91, 51, 48, 109, 47, 32, 32, 32, 162, 27, 91, 51, 55, 59, 52, 48, 109, 101, 32, 32, 32, 32, 27, 91, 51, 48, 109, 161, 27, 91, 49, 109, 107, 162, 27, 91, 59, 51, 48, 59, 52, 55, 109, 102, 32, 32, 32, 27, 91, 51, 55, 59, 52, 51, 109, 162, 103, 162, 27, 91, 52, 48, 109, 100, 27, 91, 52, 49, 109, 162, 27, 91, 51, 49, 109, 98, 27, 91, 51, 48, 109, 161, 27, 91, 51, 49, 109, 108, 27, 91, 51, 48, 109, 61, 32, 32, 27, 91, 51, 49, 109, 162, 27, 91, 52, 55, 109, 101, 27, 91, 49, 59, 51, 55, 109, 161, 195, 161, 195, 161, 195, 161, 195, 161, 195, 161, 195, 161, 195, 161, 195, 32, 27, 91, 59, 51, 55, 59, 52, 55, 109, 161, 27, 91, 52, 51, 109, 182, 27, 91, 51, 48, 59, 52, 55, 109, 162, 66, 27, 91, 51, 55, 109, 162, 27, 91, 52, 48, 109, 104, 27, 91, 49, 59, 51, 48, 109, 162, 27, 91, 59, 51, 55, 59, 52, 55, 109, 101, 27, 91, 51, 48, 109, 47, 162, 66, 27, 91, 49, 59, 52, 48, 109, 162, 27, 91, 59, 51, 55, 59, 52, 48, 109, 101, 162, 104, 27, 91, 51, 48, 59, 52, 55, 109, 32, 162, 172, 162, 27, 91, 49, 59, 52, 51, 109, 171, 27, 91, 109, 13, 10, 27, 91, 51, 49, 59, 52, 55, 109, 162, 110, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 55, 109, 163, 27, 91, 51, 48, 109, 105, 162, 107, 27, 91, 49, 59, 51, 55, 59, 52, 55, 109, 162, 27, 91, 52, 48, 109, 100, 32, 32, 27, 91, 51, 55, 109, 32, 27, 91, 52, 48, 109, 32, 27, 91, 49, 59, 51, 48, 109, 161, 27, 91, 52, 51, 109, 191, 27, 91, 59, 51, 48, 59, 52, 55, 109, 162, 107, 27, 91, 51, 49, 109, 34, 32, 32, 32, 32, 32, 162, 27, 91, 52, 49, 109, 170, 27, 91, 51, 48, 109, 161, 88, 161, 92, 95, 27, 91, 51, 49, 109, 162, 27, 91, 52, 55, 109, 103, 32, 32, 27, 91, 49, 59, 51, 51, 109, 47, 32, 32, 32, 32, 32, 32, 32, 47, 32, 32, 32, 32, 32, 27, 91, 59, 51, 48, 59, 52, 55, 109, 32, 32, 162, 106, 161, 171, 161, 172, 47, 32, 161, 171, 161, 100, 161, 172, 32, 40, 57, 27, 91, 52, 51, 109, 161, 27, 91, 52, 48, 109, 182, 27, 91, 109, 13, 10, 27, 91, 51, 48, 59, 52, 49, 109, 249, 27, 91, 52, 55, 109, 248, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 55, 109, 198, 27, 91, 51, 48, 109, 209, 92, 32, 27, 91, 51, 55, 109, 162, 27, 91, 52, 48, 109, 103, 162, 101, 162, 100, 27, 91, 49, 59, 51, 48, 109, 162, 27, 91, 52, 51, 109, 168, 27, 91, 59, 51, 48, 59, 52, 55, 109, 162, 106, 32, 32, 32, 32, 32, 32, 27, 91, 51, 55, 109, 161, 27, 91, 51, 48, 109, 115, 27, 91, 51, 55, 59, 52, 49, 109, 162, 102, 162, 27, 91, 51, 51, 109, 100, 162, 99, 162, 27, 91, 51, 48, 109, 98, 27, 91, 52, 55, 109, 162, 27, 91, 51, 55, 109, 100, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 48, 109, 32, 32, 92, 32, 32, 32, 32, 32, 96, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 51, 109, 162, 27, 91, 51, 55, 59, 52, 51, 109, 168, 27, 91, 52, 55, 109, 32, 27, 91, 109, 13, 10, 27, 91, 51, 49, 59, 52, 55, 109, 162, 109, 32, 32, 32, 27, 91, 51, 48, 109, 161, 27, 91, 51, 55, 109, 115, 27, 91, 51, 48, 109, 32, 32, 32, 32, 32, 32, 32, 32, 161, 169, 32, 32, 32, 32, 32, 32, 32, 164, 27, 91, 51, 55, 109, 72, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 49, 59, 51, 48, 109, 162, 173, 27, 91, 59, 51, 51, 59, 52, 55, 109, 161, 27, 91, 52, 51, 109, 182, 162, 27, 91, 51, 52, 109, 101, 27, 91, 51, 55, 59, 52, 52, 109, 162, 100, 162, 27, 91, 51, 51, 109, 99, 27, 91, 51, 52, 59, 52, 55, 109, 162, 27, 91, 51, 51, 109, 101, 162, 27, 91, 51, 55, 109, 98, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 48, 109, 32, 32, 32, 32, 162, 64, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 55, 109, 162, 27, 91, 51, 51, 109, 100, 162, 27, 91, 52, 51, 109, 102, 27, 91, 52, 48, 109, 162, 27, 91, 52, 55, 109, 108, 32, 27, 91, 109, 13, 10, 27, 91, 51, 49, 59, 52, 55, 109, 162, 110, 32, 27, 91, 51, 48, 109, 162, 65, 32, 32, 27, 91, 51, 55, 109, 162, 27, 91, 51, 48, 109, 98, 162, 100, 162, 101, 162, 27, 91, 51, 55, 109, 99, 32, 32, 32, 27, 91, 51, 48, 109, 161, 171, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 49, 109, 162, 173, 27, 91, 59, 51, 52, 59, 52, 51, 109, 32, 162, 27, 91, 52, 55, 109, 171, 32, 32, 32, 32, 32, 27, 91, 51, 55, 109, 162, 27, 91, 52, 52, 109, 101, 162, 27, 91, 51, 52, 59, 52, 51, 109, 99, 27, 91, 51, 48, 59, 52, 55, 109, 162, 27, 91, 51, 51, 109, 102, 162, 27, 91, 51, 55, 109, 100, 27, 91, 51, 51, 109, 32, 32, 163, 126, 161, 195, 162, 64, 32, 32, 27, 91, 51, 51, 109, 162, 64, 161, 99, 32, 27, 91, 51, 55, 109, 162, 27, 91, 51, 51, 109, 99, 162, 27, 91, 52, 51, 109, 102, 32, 32, 27, 91, 52, 55, 109, 162, 27, 91, 49, 59, 51, 48, 109, 171, 162, 106, 27, 91, 109, 13, 10, 27, 91, 51, 49, 59, 52, 55, 109, 162, 112, 32, 32, 32, 32, 27, 91, 51, 48, 109, 55, 161, 27, 91, 52, 48, 109, 182, 27, 91, 52, 55, 109, 162, 171, 32, 161, 27, 91, 52, 48, 109, 182, 161, 27, 91, 52, 55, 109, 182, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 51, 109, 162, 27, 91, 51, 55, 59, 52, 52, 109, 103, 27, 91, 51, 55, 59, 52, 55, 109, 32, 32, 32, 32, 32, 32, 32, 32, 32, 162, 27, 91, 52, 52, 109, 102, 27, 91, 51, 52, 109, 162, 27, 91, 52, 48, 109, 102, 27, 91, 51, 48, 59, 52, 51, 109, 162, 27, 91, 49, 59, 52, 48, 109, 170, 27, 91, 59, 51, 55, 59, 52, 51, 109, 161, 27, 91, 52, 55, 109, 191, 27, 91, 51, 48, 109, 162, 106, 161, 99, 46, 32, 162, 66, 32, 27, 91, 51, 55, 109, 161, 27, 91, 52, 51, 109, 187, 27, 91, 51, 48, 109, 161, 100, 161, 172, 32, 32, 32, 27, 91, 51, 55, 109, 161, 27, 91, 52, 55, 109, 182, 27, 91, 49, 59, 51, 48, 109, 93, 161, 115, 27, 91, 109, 13, 10, 27, 91, 49, 59, 51, 49, 59, 52, 49, 109, 161, 178, 27, 91, 59, 51, 49, 59, 52, 55, 109, 162, 106, 32, 27, 91, 51, 48, 109, 199, 219, 162, 171, 32, 27, 91, 51, 55, 109, 161, 27, 91, 49, 59, 51, 55, 109, 108, 27, 91, 52, 48, 109, 162, 107, 32, 27, 91, 59, 51, 48, 59, 52, 55, 109, 162, 110, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 199, 203, 32, 32, 27, 91, 51, 55, 59, 52, 51, 109, 162, 111, 27, 91, 51, 51, 59, 52, 55, 109, 162, 107, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 55, 59, 52, 52, 109, 162, 111, 27, 91, 51, 52, 59, 52, 51, 109, 162, 108, 27, 91, 51, 48, 109, 162, 27, 91, 49, 59, 52, 52, 109, 170, 27, 91, 59, 51, 55, 59, 52, 51, 109, 161, 27, 91, 51, 51, 59, 52, 55, 109, 191, 76, 123, 123, 162, 240, 161, 169, 27, 91, 51, 48, 109, 161, 116, 27, 91, 51, 55, 59, 52, 51, 109, 162, 169, 32, 162, 98, 162, 27, 91, 51, 51, 109, 99, 161, 27, 91, 52, 55, 109, 187, 27, 91, 51, 48, 109, 161, 212, 32, 32, 27, 91, 109, 13, 10, 27, 91, 49, 59, 51, 49, 59, 52, 49, 109, 34, 32, 27, 91, 59, 51, 49, 59, 52, 55, 109, 162, 27, 91, 51, 55, 109, 108, 27, 91, 51, 48, 109, 32, 162, 121, 32, 32, 32, 32, 27, 91, 51, 55, 109, 162, 27, 91, 52, 48, 109, 99, 32, 32, 32, 27, 91, 52, 55, 109, 32, 32, 32, 32, 32, 32, 162, 27, 91, 49, 59, 51, 48, 109, 169, 32, 32, 32, 32, 27, 91, 59, 51, 49, 59, 52, 55, 109, 32, 162, 27, 91, 49, 59, 51, 48, 109, 65, 121, 27, 91, 59, 51, 55, 59, 52, 55, 109, 162, 27, 91, 51, 51, 109, 99, 162, 27, 91, 51, 55, 59, 52, 51, 109, 101, 27, 91, 52, 55, 109, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 52, 52, 109, 162, 27, 91, 51, 51, 109, 112, 27, 91, 51, 48, 109, 161, 27, 91, 52, 51, 109, 73, 27, 91, 51, 51, 109, 161, 27, 91, 52, 52, 109, 187, 27, 91, 49, 59, 51, 48, 109, 162, 170, 27, 91, 52, 55, 109, 162, 101, 27, 91, 59, 51, 51, 59, 52, 55, 109, 85, 85, 32, 32, 32, 161, 27, 91, 51, 55, 109, 108, 27, 91, 51, 51, 109, 162, 27, 91, 51, 55, 109, 98, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 51, 109, 162, 100, 162, 27, 91, 52, 51, 109, 103, 27, 91, 109, 13, 10, 27, 91, 49, 59, 51, 49, 59, 52, 49, 109, 96, 27, 91, 59, 51, 48, 59, 52, 49, 109, 92, 27, 91, 51, 49, 109, 162, 27, 91, 52, 55, 109, 103, 32, 32, 27, 91, 51, 55, 109, 161, 27, 91, 49, 109, 182, 32, 32, 32, 32, 27, 91, 59, 51, 55, 59, 52, 55, 109, 162, 27, 91, 52, 48, 109, 101, 27, 91, 49, 109, 34, 27, 91, 59, 51, 55, 59, 52, 48, 109, 161, 27, 91, 52, 55, 109, 182, 32, 32, 32, 32, 32, 32, 161, 27, 91, 49, 59, 51, 48, 109, 195, 32, 32, 27, 91, 59, 51, 49, 59, 52, 55, 109, 32, 162, 65, 32, 27, 91, 51, 51, 109, 162, 27, 91, 51, 55, 59, 52, 51, 109, 100, 162, 27, 91, 52, 55, 109, 103, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 52, 59, 52, 51, 109, 161, 27, 91, 52, 52, 109, 182, 27, 91, 49, 59, 51, 48, 109, 162, 171, 32, 32, 32, 32, 162, 170, 27, 91, 52, 54, 109, 162, 27, 91, 52, 55, 109, 101, 162, 100, 162, 99, 27, 91, 59, 51, 51, 59, 52, 55, 109, 162, 98, 161, 27, 91, 51, 55, 109, 100, 161, 27, 91, 51, 51, 109, 100, 163, 27, 91, 51, 48, 59, 52, 54, 109, 105, 27, 91, 49, 59, 51, 54, 109, 161, 195, 27, 91, 59, 51, 48, 59, 52, 51, 109, 69, 27, 91, 51, 51, 109, 162, 27, 91, 51, 55, 109, 99, 27, 91, 109, 13, 10, 27, 91, 51, 55, 59, 52, 49, 109, 162, 106, 27, 91, 51, 48, 109, 162, 66, 27, 91, 51, 49, 109, 162, 27, 91, 52, 55, 109, 101, 32, 32, 27, 91, 51, 48, 109, 161, 171, 32, 161, 88, 32, 161, 170, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 51, 109, 76, 162, 27, 91, 51, 55, 59, 52, 51, 109, 100, 162, 27, 91, 52, 55, 109, 103, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 52, 59, 52, 51, 109, 161, 27, 91, 52, 52, 109, 182, 32, 27, 91, 51, 48, 109, 161, 27, 91, 51, 52, 109, 108, 27, 91, 51, 48, 109, 61, 32, 32, 32, 32, 32, 32, 27, 91, 51, 52, 59, 52, 51, 109, 162, 104, 162, 103, 27, 91, 52, 52, 109, 32, 32, 27, 91, 52, 51, 109, 162, 27, 91, 52, 55, 109, 104, 162, 102, 162, 100, 27, 91, 52, 54, 109, 162, 99, 27, 91, 52, 51, 109, 162, 100, 27, 91, 52, 55, 109, 162, 102, 27, 91, 109, 13, 10, 27, 91, 51, 55, 59, 52, 49, 109, 162, 107, 27, 91, 51, 48, 109, 162, 66, 162, 169, 27, 91, 51, 49, 59, 52, 48, 109, 162, 27, 91, 51, 48, 59, 52, 55, 109, 102, 162, 99, 162, 98, 161, 197, 32, 32, 162, 27, 91, 51, 51, 109, 98, 162, 99, 44, 161, 99, 163, 184, 42, 27, 91, 51, 55, 59, 52, 51, 109, 162, 103, 162, 27, 91, 52, 55, 109, 104, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 52, 52, 109, 162, 27, 91, 51, 51, 109, 171, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 109, 13, 10, 27, 91, 51, 55, 59, 52, 49, 109, 162, 27, 91, 51, 48, 109, 171, 32, 125, 27, 91, 51, 49, 109, 162, 27, 91, 52, 48, 109, 102, 27, 91, 51, 48, 59, 52, 49, 109, 45, 27, 91, 51, 49, 109, 162, 27, 91, 51, 51, 59, 52, 48, 109, 99, 27, 91, 52, 49, 109, 162, 27, 91, 51, 55, 59, 52, 51, 109, 100, 162, 101, 162, 102, 162, 103, 27, 91, 51, 51, 59, 52, 55, 109, 32, 32, 32, 32, 32, 161, 197, 162, 100, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 59, 51, 55, 59, 52, 55, 109, 162, 27, 91, 49, 59, 51, 48, 109, 99, 161, 27, 91, 59, 51, 52, 59, 52, 52, 109, 182, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 109, 13, 10, 27, 91, 51, 48, 59, 52, 49, 109, 32, 32, 32, 47, 27, 91, 51, 49, 109, 162, 27, 91, 51, 51, 109, 100, 162, 27, 91, 52, 51, 109, 102, 162, 27, 91, 51, 55, 109, 168, 27, 91, 51, 48, 59, 52, 55, 109, 32, 32, 163, 126, 161, 195, 161, 195, 161, 195, 161, 195, 161, 195, 161, 195, 27, 91, 49, 109, 162, 170, 92, 32, 32, 32, 32, 32, 32, 32, 32, 161, 27, 91, 59, 51, 55, 59, 52, 55, 109, 107, 161, 27, 91, 49, 59, 51, 48, 109, 107, 162, 101, 27, 91, 52, 51, 109, 162, 171, 27, 91, 59, 51, 48, 59, 52, 51, 109, 62, 27, 91, 52, 52, 109, 162, 106, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 109, 13, 10, 27, 91, 51, 48, 59, 52, 49, 109, 161, 172, 162, 65, 27, 91, 51, 49, 109, 161, 27, 91, 52, 51, 109, 182, 162, 66, 162, 66, 27, 91, 51, 55, 109, 161, 27, 91, 52, 55, 109, 191, 27, 91, 51, 48, 109, 162, 106, 91, 164, 71, 164, 71, 164, 71, 164, 71, 164, 71, 41, 32, 32, 27, 91, 49, 109, 161, 27, 91, 59, 51, 51, 59, 52, 51, 109, 191, 27, 91, 52, 55, 109, 162, 27, 91, 51, 55, 109, 102, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 49, 59, 51, 48, 59, 52, 52, 109, 162, 27, 91, 52, 51, 109, 171, 32, 32, 32, 27, 91, 52, 52, 109, 162, 107, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 59, 51, 52, 59, 52, 52, 109, 161, 27, 91, 51, 48, 109, 115, 95, 32, 32, 95, 161, 90, 44, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 109, 13, 10, 27, 91, 51, 48, 59, 52, 49, 109, 162, 172, 27, 91, 51, 55, 109, 162, 168, 27, 91, 51, 49, 59, 52, 51, 109, 162, 27, 91, 49, 59, 51, 48, 109, 170, 27, 91, 59, 51, 48, 59, 52, 51, 109, 161, 171, 161, 96, 161, 96, 27, 91, 51, 55, 109, 161, 27, 91, 52, 55, 109, 191, 27, 91, 51, 48, 109, 91, 164, 71, 164, 71, 164, 71, 164, 71, 164, 71, 161, 94, 32, 32, 27, 91, 51, 51, 109, 161, 27, 91, 52, 51, 109, 106, 27, 91, 52, 55, 109, 162, 27, 91, 51, 55, 109, 101, 32, 32, 27, 91, 51, 51, 109, 162, 98, 162, 100, 162, 27, 91, 52, 51, 109, 103, 27, 91, 51, 48, 109, 161, 27, 91, 52, 52, 109, 92, 27, 91, 52, 51, 109, 45, 163, 184, 27, 91, 51, 51, 109, 161, 27, 91, 49, 59, 51, 48, 59, 52, 52, 109, 182, 32, 32, 32, 32, 32, 27, 91, 59, 51, 52, 59, 52, 52, 109, 162, 27, 91, 51, 48, 109, 169, 32, 32, 32, 32, 32, 32, 161, 195, 32, 32, 32, 32, 32, 32, 32, 32, 27, 91, 51, 52, 109, 162, 27, 91, 49, 59, 51, 48, 109, 169, 162, 99, 162, 98, 32, 27, 91, 109, 13, 10, 32, 32, 197, 119, 170, 239, 168, 211, 168, 236, 32, 167, 229, 189, 240, 189, 240, 185, 234, 183, 126, 167, 123, 161, 65, 178, 123, 166, 98, 166, 179, 161, 105, 57, 52, 56, 53, 57, 161, 106, 166, 236, 182, 109, 165, 193, 169, 77, 167, 65, 164, 64, 176, 95, 32, 60, 40, 161, 189, 165, 215, 161, 189, 41, 32, 170, 96, 183, 78, 168, 190, 197, 206, 13, 10, 27, 91, 50, 49, 59, 49, 72, 27, 91, 75, 27, 91, 109, 189, 208, 191, 233, 164, 74, 165, 78, 184, 185, 161, 65, 169, 206, 165, 72, 32, 103, 117, 101, 115, 116, 32, 176, 209, 198, 91, 161, 65, 169, 206, 165, 72, 32, 110, 101, 119, 32, 181, 249, 165, 85, 58, 32, 27, 91, 55, 109, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8]
