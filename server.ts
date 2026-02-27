
console.log("Loading server.ts...");
import express from "express";
import { createServer as createViteServer } from "vite";
import fs from "fs";
import path from "path";
import apiApp from "./api/index";

async function startServer() {
  console.log("Starting startServer function...");
  const app = express();
  const PORT = 3000;

  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  
  app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
    next();
  });

  console.log("Registering API routes...");
  // Health check for the platform
  app.get("/health", (req, res) => {
    res.json({ status: "ok", timestamp: new Date().toISOString() });
  });

  // Use the API routes from /api/index.ts
  app.use("/api", apiApp);

  console.log(`Attempting to listen on port ${PORT}...`);
  const server = app.listen(PORT, "0.0.0.0", async () => {
    console.log(`Server successfully running on http://localhost:${PORT}`);
    
    // Vite middleware for development - start after listening
    const distPath = path.join(process.cwd(), "dist");
    const useVite = process.env.NODE_ENV !== "production" || !fs.existsSync(distPath);

    if (useVite) {
      console.log("Starting Vite in middleware mode...");
      try {
        const vite = await createViteServer({
          server: { middlewareMode: true },
          appType: "spa",
        });
        app.use(vite.middlewares);
        console.log("Vite middleware attached.");
      } catch (viteError) {
        console.error("Failed to start Vite:", viteError);
      }
    } else {
      console.log(`Serving static files from ${distPath}`);
      app.use(express.static(distPath));
      app.get("*", (req, res) => {
        res.sendFile(path.join(distPath, "index.html"));
      });
    }
  });

  // Global error handler
  app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error("Unhandled Error:", err);
    res.status(500).json({ 
      error: "Internal Server Error", 
      message: process.env.NODE_ENV === 'development' ? err.message : "Đã xảy ra lỗi hệ thống" 
    });
  });
}

startServer();
