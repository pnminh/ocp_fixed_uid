# Run pod as specific user
In this example, the user `default` with uid=1001 is used
1. Create `Dockerfile` that add user `1001`
    ```Dockerfile
    ...
    RUN useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
        -c "Default Application User" default && \
    chown -R 1001:0 ${APP_ROOT}
    USER 1001
    ```
2. Create scc with kind `SecurityContextConstraints` for user `1001` (`uid1001.yaml`)
    ```bash
    oc apply -f uid1001.yaml securitycontextconstraints.security.openshift.io/uid1001 created
    ```
3. Create a service account that will use the new scc
    ```bash
    oc create sa uid1001-sa
    serviceaccount/uid1001-sa created
    ```
4. Assign the scc to the new service account
    ```bash
    oc adm policy add-scc-to-user uid1001 -z uid1001-sa
    securitycontextconstraints.security.openshift.io/uid1001 added to: ["system:serviceaccount:fixed-uid:uid1001-sa"]
    ```
5. Add the service account to the deployment config for the app that uses the Dockerfile above
    ```bash
    oc patch dc/fixed-uid --patch '{"spec":{"template":{"spec":{"serviceAccountName": "uid1001-sa"}}}}'
    deploymentconfig.apps.openshift.io/fixed-uid patched
    ```