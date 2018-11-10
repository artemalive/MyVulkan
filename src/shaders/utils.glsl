struct Ray {
    vec3 origin;
    vec3 dir;
    vec3 rx_dir;
    vec3 ry_dir;
};

vec3 get_direction(vec2 film_position) {
    const float tan_fovy_over_2 = 0.414; // tan(45/2)

    vec2 uv = film_position / vec2(gl_LaunchSizeNVX.xy);
    float aspect_ratio = float(gl_LaunchSizeNVX.x) / float(gl_LaunchSizeNVX.y);
    float horz_half_dist = aspect_ratio * tan_fovy_over_2;
    float vert_half_dist = tan_fovy_over_2;
    vec2 uv2 = 2.0 * uv - 1.0;
    float dir_x = uv2.x * horz_half_dist;
    float dir_y = -uv2.y * vert_half_dist;
    return normalize(vec3(dir_x, dir_y, -1.f));
}

Ray generate_ray(mat4x3 camera_to_world, vec2 film_position) {
    Ray ray;
    ray.origin = camera_to_world[3];
    ray.dir = camera_to_world * vec4(get_direction(film_position), 0);
    ray.rx_dir = camera_to_world * vec4(get_direction(vec2(film_position.x + 1.f, film_position.y)), 0);
    ray.ry_dir = camera_to_world * vec4(get_direction(vec2(film_position.x, film_position.y + 1.f)), 0);
    return ray;
}

void solve_2x2_helper(float a, float b, float c, float d, out vec2 c1, out vec2 c2) {
    // |a b| |x1|  |b1|
    // |c d| |x2|  |b2|
    float det = a*d - b*c;

    float inv_det = 0.0;
    if (abs(det) > 1e-6)
         inv_det = 1.0 / det;

    c1 = inv_det * vec2(d, -b);
    c2 = inv_det * vec2(-c, a);
}

float ray_plane_intersection(vec3 ray_o, vec3 ray_d, vec3 plane_n, float plane_d)
{
    return (-plane_d - dot(plane_n, ray_o)) / dot(plane_n, ray_d);
}

vec2 barycentric_interpolate(float b1, float b2, vec2 v0, vec2 v1, vec2 v2)
{
    return (1.0 - b1 - b2)*v0 + b1*v1 + b2*v2;
}

vec3 barycentric_interpolate(float b1, float b2, vec3 v0, vec3 v1, vec3 v2)
{
    return (1.0 - b1 - b2)*v0 + b1*v1 + b2*v2;
}