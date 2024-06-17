﻿/* Copyright (C) Itseez3D, Inc. - All Rights Reserved
* You may not use this file except in compliance with an authorized license
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* UNLESS REQUIRED BY APPLICABLE LAW OR AGREED BY ITSEEZ3D, INC. IN WRITING, SOFTWARE DISTRIBUTED UNDER THE LICENSE IS DISTRIBUTED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
* CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED
* See the License for the specific language governing permissions and limitations under the License.
* Written by Itseez3D, Inc. <support@avatarsdk.com>, March 2021
*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ItSeez3D.AvatarSdk.Core
{
	public enum ExportTemplate
	{
		FULLBODY, 
		HEAD
	}

	public static class ExportTemplateExtensions
	{
		public static string ExportTemplateToStr(this ExportTemplate template)
		{
			switch (template)
			{
				case ExportTemplate.FULLBODY: return "full body";
				case ExportTemplate.HEAD: return "head";
				default: return "unknown";
			}
		}

		public static ExportTemplate ExportTemplateFromStr(string str)
		{
			str = str.ToLower();
			if (str == "full body")
				return ExportTemplate.FULLBODY;
			if (str == "head")
				return ExportTemplate.HEAD;

			Debug.LogErrorFormat("Unable to convert string '{0}' to ExportTemplate.", str);
			return ExportTemplate.FULLBODY;
		}
	}
}
