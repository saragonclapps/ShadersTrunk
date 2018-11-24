using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Material))]
public class MovietexturePlay : MonoBehaviour {

    private MovieTexture movie;

	void Start () {
        movie = (MovieTexture)GetComponent<Renderer>().material.GetTexture("_Glitch");
        movie.loop = true;
        movie.Play();
	}
}
