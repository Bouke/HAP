Design
======

## Object-Oriented Design

A high-level overview of the objects involved are shown in the diagram below.
The terminology of HAP (Device, Accessory, Service, Characteristic) is
followed for ease of understanding.

```
                      +------------+
                      | NetService |
                      +------------+
                             |
                             | delegate
                             v
   +--------+ 1     0…1 +--------+ *   * +---------------------+
   | Device |-----------| Server |-------| Controller (iPhone) |
   +--------+           +--------+       +---------------------+
        | 1                           * /
        | *                           /
  +-----------+                     /
  | Accessory |                   /
  +-----------+                 /
        | 1                   / > read, events
        | *                 / < write, subscribe
   +---------+            /
   | Service |          /
   +---------+        /
        | 1         /
        | *     * /
+----------------+
| Characteristic |
+----------------+
```
