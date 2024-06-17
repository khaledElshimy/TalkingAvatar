using System.Collections.Generic;
using System.Linq;
using GLTF.Extensions;
using itSeez3D.Newtonsoft.Json;

namespace GLTF.Schema
{
	/// <summary>
	/// A set of primitives to be rendered. A node can contain one or more meshes.
	/// A node's transform places the mesh in the scene.
	/// </summary>
	public class GLTFMesh : GLTFChildOfRootProperty
	{
		/// <summary>
		/// An array of primitives, each defining geometry to be rendered with
		/// a material.
		/// <minItems>1</minItems>
		/// </summary>
		public List<MeshPrimitive> Primitives;

		/// <summary>
		/// Array of weights to be applied to the Morph Targets.
		/// <minItems>0</minItems>
		/// </summary>
		public List<double> Weights;

		public List<string> TargetNames;

		public GLTFMesh()
		{
		}

		public GLTFMesh(GLTFMesh mesh, GLTFRoot gltfRoot) : base(mesh, gltfRoot)
		{
			if (mesh == null) return;

			if (mesh.Primitives != null)
			{
				Primitives = new List<MeshPrimitive>(mesh.Primitives.Count);

				foreach (MeshPrimitive primitive in mesh.Primitives)
				{
					Primitives.Add(new MeshPrimitive(primitive, gltfRoot));
				}
			}

			if (mesh.Weights != null)
			{
				Weights = mesh.Weights.ToList();
			}
		}


		public static GLTFMesh Deserialize(GLTFRoot root, JsonReader reader)
		{
			var mesh = new GLTFMesh();

			while (reader.Read() && reader.TokenType == JsonToken.PropertyName)
			{
				var curProp = reader.Value.ToString();

				switch (curProp)
				{
					case "primitives":
						mesh.Primitives = reader.ReadList(() => MeshPrimitive.Deserialize(root, reader));
						break;
					case "weights":
						mesh.Weights = reader.ReadDoubleList();
						break;
					case "extras":
						// GLTF does not support morph target names, serialize in extras for now
						// https://github.com/KhronosGroup/glTF/issues/1036
						if (reader.Read() && reader.TokenType == JsonToken.StartObject)
						{
							while (reader.Read() && reader.TokenType == JsonToken.PropertyName)
							{
								var extraProperty = reader.Value.ToString();
								switch (extraProperty)
								{
									case "targetNames":
										mesh.TargetNames = reader.ReadStringList();
										break;
								}
							}
						}
						break;
					default:
						mesh.DefaultPropertyDeserializer(root, reader);
						break;
				}
			}

			return mesh;
		}

		public override void Serialize(JsonWriter writer)
		{
			writer.WriteStartObject();

			if (Primitives != null && Primitives.Count > 0)
			{
				writer.WritePropertyName("primitives");
				writer.WriteStartArray();
				foreach (var primitive in Primitives)
				{
					primitive.Serialize(writer);
				}
				writer.WriteEndArray();
			}

			if (Weights != null && Weights.Count > 0)
			{
				writer.WritePropertyName("weights");
				writer.WriteStartArray();
				foreach (var weight in Weights)
				{
					writer.WriteValue(weight);
				}
				writer.WriteEndArray();
			}

			base.Serialize(writer);

			writer.WriteEndObject();
		}
	}
}
